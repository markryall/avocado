require 'avocado'

class Avocado::Lists
  attr_reader :client

  def initialize client
    @client = client
  end

  def all
    client.get '/api/lists'
  end

  def create name
    client.post '/api/lists', name: name
  end

  def show id
    client.get "/api/lists/#{id}"
  end

  def delete id
    client.post "/api/lists/#{id}/delete"
  end
end
