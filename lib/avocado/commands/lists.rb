require 'avocado/commands'

class Avocado::Commands::Lists
  attr_reader :api, :config

  def initialize api, config
    @api, @config = api, config
  end

  def execute args
    command = args.shift
    case command
    when nil
      list
    when 'create'
      create args
    when 'show'
      show args
    end
  end

  def list
    lists = []
    api.lists.all.each_with_index do |list, index|
      lists << list['id']
      puts "#{index + 1}) #{list['name']} (#{list['items'].count} items)"
    end
    config['lists'] = lists
  end

  def create
    api.lists.create args.join(' ')
  end

  def show args
    id = config['lists'][args.first.to_i - 1]
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
end
