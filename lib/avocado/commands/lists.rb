require 'avocado/commands'

class Avocado::Commands::Lists
  attr_reader :api, :config

  def initialize api, config
    @api, @config = api, config
  end

  def execute args
    list_command = args.shift
    case list_command
    when nil
      list
    when 'create'
      create args
    end
  end

  def list
    api.lists.each do |list|
      puts "#{list['id']} #{list['name']} (#{list['items'].count} items)"
    end
  end

  def create
    api.lists.create args.join(' ')
  end
end
