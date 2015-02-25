require 'avocado/config'
require 'avocado/client'
require 'avocado/api'

module Avocado
  module Cli
    def self.execute *args
      command = args.shift
      case command
      when 'us'
        me, you = api.users
        puts "You are #{me['firstName']} and your partner is #{you['firstName']}"
      when 'say'
        api.say ARGV.join(' ')
      when 'messages'
        me, you = api.users
        users = {
          me['id'] => me['firstName'],
          you['id'] => you['firstName'],
        }
        api.activities.each do |event|
          puts "#{users[event['userId']]}: #{event['data']['text']}" if event['type'] == 'message'
        end
      when 'hug'
        api.hug
      else
        puts "unknown command '#{command}'" if command
        puts 'avocado us              - show some information about you and your partner'
        puts 'avocado hug             - hug your partner'
        puts 'avocado say <something> - say <something> to your partner'
      end
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
