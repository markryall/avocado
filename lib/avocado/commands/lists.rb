require 'avocado/commands'
require 'avocado/commands/list_items'

class Avocado::Commands::Lists
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
    when 'show'
      config['list'] = config['lists'][args.shift.to_i - 1]
      Avocado::Commands::ListItems.new(api, config, args).list
    when 'items'
      Avocado::Commands::ListItems.new(api, config, args).execute
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

  def delete
    id = config['lists'][args.shift.to_i - 1]
    api.lists.delete(id)
  end
end
