require 'avocado'

class Avocado::Lists
  attr_reader :client

  def initialize client
    @client = client
  end

  def each
    client.get('/api/lists').each { |list| yield list }
  end

  def create name
    client.post '/api/lists', name: name
  end
end
