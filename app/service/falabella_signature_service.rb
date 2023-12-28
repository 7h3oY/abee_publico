require 'openssl'
require 'date'
require 'net/http'
require 'uri'

class FalabellaSignatureService
  attr_reader :errors

  def initialize()
    @errors = []
  end

  # Método para generar la firma HMAC-SHA256
  def generate_signature(api_signature, parameters)

    sorted_parameters = parameters.sort.to_h
    encoded_parameters = sorted_parameters.map { |name, value| "#{URI.encode_www_form_component(name)}=#{URI.encode_www_form_component(value)}" }

    concatenated = encoded_parameters.join('&')

    signature = OpenSSL::HMAC.hexdigest('sha256', api_signature, concatenated)



    URI.encode_www_form_component(signature)
  end

  # Método para realizar una solicitud a la API de Falabella
  def make_falabella_request(action,userID,api_key,timestamp)
    api_signature = api_key
    parameters = {
      'Action' => action,
      'Format' => 'JSON',
      'Version' => '1.0',
      'Timestamp' =>timestamp,
      'UserID' => userID,

    }
    parameters['Signature'] = generate_signature(api_signature, parameters)

    parameters['Signature']
  end

end
