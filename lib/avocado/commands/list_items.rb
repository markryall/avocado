require 'avocado/commands'

class Avocado::Commands::ListItems
  attr_reader :api, :config, :args

  def initialize api, config, args
    @api, @config, @args = api, config, args
  end

  def execute
    id = config['lists'][args.shift.to_i - 1]
    command = args.shift
    case command
    when nil
      list id
    when 'create'
      create id
    end
  end

  def list id
    items = []
    list = api.lists.show(id)
    puts list['name']
    list['items'].each_with_index do |item, index|
      items << item['id']
      puts "#{index + 1}) [#{item['complete'] ? 'x' : ' '}] #{item['text']}"
    end
    config['list'] = id
    config['items'] = items
  end

  def create id
    api.lists.create_item id, args.join(' ')
  end
end
