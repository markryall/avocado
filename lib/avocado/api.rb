require 'avocado/lists'

module Avocado
  def self.API(*args)
    Avocado::API.new *args
  end
end

class Avocado::API
  attr_reader :client, :lists

  def initialize client
    @client = client
    @lists = Avocado::Lists.new client
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

  def activities after=nil
    client.get after ? "/api/activities?after=#{after}" : '/api/activities'
  end

  def say message
    client.post '/api/conversation', message: message
  end

  def hug
    client.post '/api/hug'
  end
end
