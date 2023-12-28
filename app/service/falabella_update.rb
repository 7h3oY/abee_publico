require 'net/http'
require 'builder'
require 'json'

#require_relative 'falabella_signature_service'

class FalabellaUpdate
  attr_reader :errors
  now = DateTime.now
  CREDENCIALES = {
    Action: '',
    UserID: '',
    api_key: '',
    Signature:'',
    Timestamp: now.strftime('%Y-%m-%dT%H:%M:%S%:z'),
  }

  def initialize(userID:,apitoken:,action:)
    CREDENCIALES[:UserID] = userID
    CREDENCIALES[:api_key] = apitoken
    CREDENCIALES[:Action]=action
    @signature_service = FalabellaSignatureService.new
    CREDENCIALES[:Signature]= @signature_service.make_falabella_request(action,userID,apitoken,CREDENCIALES[:Timestamp])
    @errors = []
  end

  def actualizar_productos(productos:)

  #  CREDENCIALES[:Action]='GetProducts'
   # response=get_falabella()
    response=update_product_post(productos: productos)
    puts response
    response
  end

  private

  def build_xml_request(productos:)

    xml_builder = Builder::XmlMarkup.new(indent: 2)
    xml_builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'
    #xml_builder.Signature CREDENCIALES[:Signature]
    xml_builder.Request do
      productos.each do |product_update|
        xml_builder.Product do
          xml_builder.SellerSku product_update['sku']
          xml_builder.BusinessUnits do
            xml_builder.BusinessUnit do
              xml_builder.OperatorCode 'facl'
              xml_builder.Stock product_update['cantidad']
            end
          end
        end
      end
    end
    xml_builder.target!
  end

  def update_product_post(productos:)
    xml_request_body = build_xml_request(productos: productos)
    response = post_falabella( xml_request_body)
    response
  end



  def post_falabella(request_body)
    signature = CREDENCIALES[:Signature]
    uri = URI("https://sellercenter-api.falabella.com/?Action=#{CREDENCIALES[:Action]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    parameters = {
      'Action' => CREDENCIALES[:Action],
      'Format' => 'JSON',
      'Version' => '1.0',
      'Timestamp' =>CREDENCIALES[:Timestamp],
      'UserID' => CREDENCIALES[:UserID],
      'Signature' => signature
    }

    uri.query = URI.encode_www_form(parameters)

    request = Net::HTTP::Post.new(uri)
    request['Accept'] = 'application/xml'
    request['Content-Type'] = 'application/xml'
    request.body = request_body
    response= http.request(request)
    respuesta= JSON.parse(response.read_body)
    respuesta
  end

def get_falabella()
url_full= "https://sellercenter-api.falabella.com/"
url_full+= "?Action=#{CREDENCIALES[:Action]}&Version=1.0&Format=JSON&Filter=all&Limit=1000&GlobalIdentifier=0"
url_full+= "&UserID=#{CREDENCIALES[:UserID]}"
url_full+= "&Signature=#{CREDENCIALES[:Signature]}"
url_full+= "&Timestamp=#{CREDENCIALES[:Timestamp]}"
puts url_full
url = URI(url_full)

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'

response = http.request(request)
response.class
puts response.read_body

response.read_body
  end





end
