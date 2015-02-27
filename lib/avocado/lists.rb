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

  def create_item id, text
    client.post "/api/lists/#{id}", text: text
  end

  def delete_item list_id, item_id
    client.post "/api/lists/#{list_id}/#{item_id}/delete"
  end

  def edit_item list_id, item_id, params
    client.post "/api/lists/#{list_id}/#{item_id}", params
  end
end
