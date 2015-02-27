require 'avocado/commands'

class Avocado::Commands::Messages
  include Avocado::Users
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
    end
  end

  def list
    users = {
      me['id'] => me['firstName'],
      you['id'] => you['firstName'],
    }
    last = config.peek(:lastActivity)
    api.activities(last).each do |event|
      if event['type'] == 'message'
        user = users[event['userId']]
        message = event['data']['text']
        last = event['timeCreated'].to_i
        at = Time.at(last/1000).strftime('%d/%m %H:%M:%S')
        puts "#{at} #{user}: #{message}"
      end
    end
    config[:lastActivity] = last
  end

  def create args
    api.say args.join(' ')
  end
end
