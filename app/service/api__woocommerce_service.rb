require "uri"
require "net/http"
require 'json'
class ApiWoocommerceService
  attr_reader :errors

  CREDENCIALES = {
      consumer_key: '',
      consumer_secret: '',
      unidos: ''
    }
    @URL = ''


  def initialize(url:, consumer_key:, consumer_secret:)
    CREDENCIALES[:consumer_key]=consumer_key
    CREDENCIALES[:consumer_secret]=consumer_secret
    CREDENCIALES[:unidos]="consumer_key=#{consumer_key}&consumer_secret=#{consumer_secret}"
    @URL=url

  end

  def actualizar_inventario(productos:)
    retorno = []
    con_error=0
    if @URL
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
    end

     retorno
  end



  private

  def acualizar_producto(sku:, cantidad:)

      url = URI("#{@URL}/wp-json/wc/v3/products/?sku=#{sku}&#{CREDENCIALES[:unidos]}")

     https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "total_page=1"
        response = https.request(request)

        respuesta1= JSON.parse(response.read_body)


       id =(respuesta1[0])? respuesta1[0]['id'] : '0'

     if  id!='0'
        url = URI("#{@URL}/wp-json/wc/v3/products/#{id}?&#{CREDENCIALES[:unidos]}")
        pp url
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = Net::HTTP::Put.new(url)
        request["Content-Type"] = "application/json"
        request["Cookie"] = "total_page=1; total_page=1; total_page=1"
        request.body = JSON.dump({
          "stock_quantity": "#{cantidad}"
        })
        response = https.request(request)

        respuesta= JSON.parse(response.read_body)
      else
       respuesta = {
        'error' => "No se encontro el producto SKU: #{sku}",
      }


     end
     respuesta
 end


end
