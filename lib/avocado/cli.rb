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
      when 'hug'
        api.hug
      else
        puts "unknown command '#{command}'" if command
        puts 'avocado hug'
        puts 'avocado say <what you would like to say'
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
