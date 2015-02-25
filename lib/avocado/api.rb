require 'avocado'

module Avocado
  def self.API(*args)
    Avocado::API.new *args
  end
end

class Avocado::API
  AVOCADO_API_URL_COUPLE = '/api/couple'

  attr_reader :auth_client

  def initialize auth_client
    @auth_client = auth_client
  end

  def couple
    @couple ||= update_couple
  end

  def update_couple
    connection = Net::HTTP::new(Avocado.host, Avocado.port)
    connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    connection.use_ssl = true
    resp = connection.get AVOCADO_API_URL_COUPLE, auth_client.signed_headers
    if resp.code == "200"
      @couple = resp.body
    end
  end
end
