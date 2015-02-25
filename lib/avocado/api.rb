require 'avocado'

module Avocado
  def self.API(*args)
    Avocado::API.new *args
  end
end

class Avocado::API
  attr_reader :client

  def initialize client
    @client = client
  end

  def users
    client.get '/api/user'
  end

  def user id
    client.get "/api/user/#{id}"
  end

  def couple
    client.get '/api/couple'
  end

  def activities
    client.get '/api/activities'
  end

  def say message
    client.post '/api/conversation', message: message
  end

  def hug
    client.post '/api/hug'
  end
end
