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

  def create
    builder = Avocado::EventBuilder.new
    event = builder.build args.join(' ')
    if event
      response = api.events.create event.params
    else
      builder.usage
    end
  end
end
