require 'avocado'

class Avocado::Events
  attr_reader :client

  def initialize client
    @client = client
  end

  def all
    client.get '/api/calendar'
  end

  def create params
    client.post '/api/calendar', params
  end
end
