require 'avocado/commands'

class Avocado::Commands::Messages
  include Avocado::Users
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
    end
  end

  def list
    last = config.peek(:lastActivity)
    messages = api.activities(last).find_all {|a| a['type'] == 'message' }
    if messages.empty?
      puts last ? "No messages since #{time last}" : "No messages"
    else
      messages.each { |m| show_message m }
      last = messages.last['timeCreated']
    end
    config[:lastActivity] = last
  end

  def create
    api.say args.join(' ')
  end

  private

  def show_message message
    user = users_hash[message['userId']]
    text = message['data']['text']
    puts "#{time message['timeCreated']} #{user}: #{text}"
  end

  def time ms
    Time.at(ms.to_i/1000).strftime('%d/%m %H:%M:%S')
  end
end
