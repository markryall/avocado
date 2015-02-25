require 'avocado'

module Avocado
  def self.API(*args)
    Avocado::API.new *args
  end
end

class Avocado::API
  AVOCADO_API_URL_COUPLE = '/api/couple'

  attr_reader :client

  def initialize client
    @client = client
  end

  def couple
    @couple ||= update_couple
  end

  private

  def update_couple
    client.get AVOCADO_API_URL_COUPLE
  end
end
