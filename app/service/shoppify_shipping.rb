require 'shopify_api'
require 'json'
require 'net/http'
require 'active_resource'



class ShoppifyShipping
  attr_reader :errors

  CREDENCIALES = {
    api_key: '510a4afdbcedee538d59b6e4d5d96604',
    api_secret_key: 'f6e94f9c95fa92d3c938e67a14fef008',
    refresh_token_tienda: '',
    order_id: '',
    status_shipping: '',
    secret_token_tienda: '',
    nombre_tienda: '',
    data_clave: '',
  }

  URLS = {
    tienda_url: '',
    autorizacion: 'mokups.000webhostapp.com/php/Shopify.php',
  }

  @@access_token = nil
  @@api_sesion = nil
  @@retorno = []

  def initialize(tienda_url:, token_tienda:, refresh_token:, nombre_tienda:)
    URLS[:tienda_url] = tienda_url
    CREDENCIALES[:secret_token_tienda] = token_tienda
    CREDENCIALES[:nombre_tienda] = nombre_tienda
    CREDENCIALES[:refresh_token_tienda] = refresh_token
    self.class.verificar_token()
    @@api_sesion = ShoppifyShipping.shopify_session()
    @errors = []
  end

  def self.actualizar_shipping(order_id:, fulfillments: T::Array[T::Hash[Symbol, T.untyped]])
    if @@access_token     
        fulfillments.each do |fulfillment_abee|
          fulfillment_event = ShopifyAPI::FulfillmentEvent.new(session: @@api_sesion)
          fulfillment_id = fulfillment_abee[:fulfillment_id]
          status = fulfillment_abee[:status]
          fulfillment_event.order_id = order_id
          fulfillment_event.fulfillment_id = fulfillment_id
          fulfillment_event.status = status
          fulfillment_event.save!
        end
        status_fulfillment = fulfillments.map {|f| f[:status]}.uniq
        case status_fulfillment.length
        when 1          
          status_orden = status_fulfillment.first
          respuesta = actualizar_status_orden(order_id, status_orden)
        when 2
          status_orden = 'open'
          respuesta = actualizar_status_orden(order_id, status_orden)
        end 
        @@retorno.push(respuesta.body)
    end
    @@retorno << "Creando nuevo Token"
  end

  def self.actualizar_status_orden(order_id,status_orden)
    api_sesion = ShoppifyShipping.shopify_session()
    order = ShopifyAPI::Order.new(session: api_sesion)
    order.id = order_id
    if status_orden == 'open' && status_orden == 'in_transit'
      order.open(
        session: api_sesion,
      )
      response = order.open(sesion: api_sesion)
    elsif status_orden == 'close'
      order.close(
        session: api_sesion,
      )
      response = order.open(sesion: api_sesion)
    else status_orden == 'cancel'
      order.cancel(
        session: api_sesion,
      )
      response = order.open(sesion: api_sesion)
    end
  end

  def self.verificar_token
    if data_clave = Token.where(token_tienda: CREDENCIALES[:secret_token_tienda], tienda: CREDENCIALES[:nombre_tienda])
         access_token = renovar_token
    elsif
        @@access_token = CREDENCIALES[:secret_token_tienda]
    end
  end
  
  def self.renovar_token
    cliente = OAuth2::Client.new(
      api_key: CREDENCIALES[:cliente_id],
      api_secret: CREDENCIALES[:cliente_secret],
      site: URLS[:tienda_url],
      token_url: '/admin/oauth/access_token'
    )
    token = OAuth2::AccessToken.new(client, access_token, refresh_token: CREDENCIALES[:refresh_token])
    new_token = token.refresh!
    @@access_token = new_token.token
    refresh_token = new_token.refresh_token if new_token.refresh_token
    @@access_token
    @@retorno.push(new_token)
  end

  private

  def self.shopify_session
    ShopifyAPI::Context.setup(
      api_key: CREDENCIALES[:api_key], 
      api_secret_key: CREDENCIALES[:api_secret_key], 
      api_version: '2023-10',
      scope: 'read_products,read_orders,write_orders',
      is_private: false,
      is_embedded: false
    )
    api_session = ShopifyAPI::Auth::Session.new(
      shop: URLS[:tienda_url],
      access_token: CREDENCIALES[:secret_token_tienda],
    )
  end
end  
