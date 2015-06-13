require 'avocado/commands'
require 'avocado/event_builder'

class Avocado::Commands::Events
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
    end
  end

  def list
    api.events.all.each_with_index do |event, index|
      puts "#{event}"
    end
  end

  def create *args
    builder = Avocado::EventBuilder.new(*args)
    if builder.errors
      builder.errors.each {|e| puts e}
    else
      api.events.create builder.event.params
    end
  end
end
