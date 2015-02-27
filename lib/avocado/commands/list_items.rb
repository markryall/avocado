require 'avocado/commands'

class Avocado::Commands::ListItems
  attr_reader :api, :config, :args

  def initialize api, config, args
    @api, @config, @args = api, config, args
  end

  def execute
    command = args.shift
    case command
    when nil
      list
    when 'create'
      create
      list
    when 'delete'
      delete
      list
    when 'complete'
      completion 1
      list
    when 'incomplete'
      completion 0
      list
    end
  end

  def list
    items = []
    list = api.lists.show(list_id)
    puts list['name']
    list['items'].each_with_index do |item, index|
      items << item['id']
      puts "#{index + 1}) [#{item['complete'] ? 'x' : ' '}] #{item['text']}"
    end
    config['items'] = items
  end

  def create
    api.lists.create_item list_id, args.join(' ')
  end

  def delete
    api.lists.delete_item list_id,item_id
  end

  def completion value
    api.lists.edit_item list_id, item_id, complete: value
  end

  def item_id
    config['items'][args.shift.to_i - 1]
  end

  def list_id
    config['list']
  end
end
