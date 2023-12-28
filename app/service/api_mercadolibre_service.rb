require "uri"
require "net/http"
require 'json'
class ApiMercadolibreService
  attr_reader :errors

  CREDENCIALES = {
      organization_id: '',
      app_id: '7368586274007140',
      app_secret: '9RM6UpxcoNABdwpSOQMKCKNsFE1XKLlM',
      market_id: "",
      market_code: "",
      access_token: '',
      respuesta: [],
    }
    URLS = {
      app: 'https://intranerd.cl/MeLi.php',
      token: 'https://api.mercadolibre.com/oauth/token',
      buscar_id_item: "",
      item: 'https://api.mercadolibre.com/items/',
      shipment: 'https://api.mercadolibre.com/shipments/'
    }
  def initialize(organization_id:,market_id:, market_code:)
    CREDENCIALES[:organization_id]=organization_id
    CREDENCIALES[:market_id]=market_id
    CREDENCIALES[:market_code]=market_code
    URLS[:buscar_id_item]="https://api.mercadolibre.com/users/#{market_id}/items/search?seller_sku="



  end
  def actualizar_inventario(productos:)
    access_token= chequear_token
    retorno=[]
    con_error=0
    if access_token
      productos.each do | producto|
        sku= producto.dig('sku')
        cantidad= producto.dig('cantidad')
        respuesta = acualizar_producto(sku: sku, cantidad: cantidad)
        retorno.push(respuesta)
        if respuesta.key?('error')
           con_error+= 1
        end

      end

      if con_error>0
        retorno = {
        'error' => "No se actualizaron todos los productos",
        'resultado' => retorno
      }

      end

    else
      retorno.push(CREDENCIALES[:respuesta])
      retorno['error']='Token no obtenido'
    end

    retorno

  end



  def chequear_token
    organization_id= CREDENCIALES[:organization_id];

    if @data_clave = Token.find_by( organization_id: organization_id, tienda: 'mercado_libre')
      access_token=refrescar_token
    else
      access_token=obtener_Token(organization_id: organization_id)
    end
    access_token

  end

  private




  def acualizar_producto(sku:, cantidad:)

    url = URI("#{URLS[:buscar_id_item]}#{sku}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request[:Authorization] = "Bearer #{CREDENCIALES[:access_token]}"
    response = https.request(request)
    respuesta= JSON.parse(response.read_body)
    respuesta.delete('available_orders')
    respuesta.delete('orders')

    item_id= respuesta['results'][0]

     if  item_id
        url =URI("#{URLS[:item]}#{item_id}")
        pp url
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Put.new(url)
        request[:Authorization] = "Bearer #{CREDENCIALES[:access_token]}"
        request["Content-Type"] = "application/json"
        request.body = "{\"available_quantity\": #{cantidad},}"
        response = https.request(request)
        respuesta= JSON.parse(response.read_body)
     else
      respuesta['error']= "No se encontro el producto SKU: #{sku}"

     end

     respuesta
  end





  def refrescar_token
    refresh_token= @data_clave[:datos_respuesta].dig('refresh_token')
    url = URI(URLS[:token])
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/json"
    request["content-type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=refresh_token&client_id=#{CREDENCIALES[:app_id]}"
    request.body +="&client_secret=#{CREDENCIALES[:app_secret]}"
    request.body +="&refresh_token=#{refresh_token}"
    response = https.request(request)
    respuesta= JSON.parse(response.read_body)
    CREDENCIALES[:respuesta]=respuesta
    access_token= respuesta.dig('access_token')
    CREDENCIALES[:access_token]=access_token;
    @data_clave.update(token_actual: access_token, datos_respuesta:respuesta )
    access_token
  end



  def obtener_Token (organization_id:)

    url = URI(URLS[:token])
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["accept"] = "application/json"
    request["content-type"] = "application/x-www-form-urlencoded"

    request.body = "grant_type=authorization_code&client_id=#{CREDENCIALES[:app_id]}"
    request.body +="&client_secret=#{CREDENCIALES[:app_secret]}"
    request.body +="&code=#{CREDENCIALES[:market_code]}"
    request.body +="&redirect_uri=https%3A%2F%2Fintranerd.cl%2FMeLi.php"

    response = https.request(request)
    respuesta= JSON.parse(response.read_body)
    CREDENCIALES[:respuesta]=respuesta
    access_token= respuesta.dig('access_token')
    CREDENCIALES[:access_token]=access_token;
    @data_clave = Token.new(organization_id: organization_id, token_actual: access_token, datos_respuesta:respuesta, tienda:'mercado_libre')
    @data_clave.save
    access_token


  end


end
