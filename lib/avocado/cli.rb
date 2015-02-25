require 'avocado/config'
require 'avocado/client'
require 'avocado/api'

module Avocado
  module Cli
    def self.execute *args
      command = args.shift
      case command
      when 'us'
        puts "You are #{me['firstName']} and your partner is #{you['firstName']}"
      when 'say'
        api.say args.join(' ')
      when 'messages'
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
      when 'hug'
        api.hug
      else
        puts "unknown command '#{command}'" if command
        puts 'avocado us              - show some information about you and your partner'
        puts 'avocado hug             - hug your partner'
        puts 'avocado say <something> - say <something> to your partner'
        puts 'avocado messages        - show messages (since last checked)'
      end
    end

    def self.me
      users.first
    end

    def self.you
      users.last
    end

    def self.users
      @users ||= api.users
    end

    def self.api
      @api ||= Avocado::API client
    end

    def self.client
      @client ||= Avocado::Client config
    end

    def self.config
      @config ||= Avocado::Config.new
    end
  end
end
