require 'avocado/config'
require 'avocado/client'
require 'avocado/api'
require 'avocado/users'
require 'avocado/commands/messages'
require 'avocado/commands/lists'

module Avocado
  module Cli
    extend Avocado::Users

    def self.execute *args
      command = args.shift
      case command
      when 'us'
        puts "You are #{me['firstName']} and your partner is #{you['firstName']}"
      when 'messages'
        Avocado::Commands::Messages.new(api, config, args).execute
      when 'hug'
        api.hug
      when 'lists'
        Avocado::Commands::Lists.new(api, config, args).execute
      else
        puts "unknown command '#{command}'" if command
        puts 'avocado us                             - show some information about you and your partner'
        puts 'avocado hug                            - hug your partner'
        puts 'avocado messages                       - show messages (since last checked)'
        puts 'avocado messages create <message>      - say <message> to your partner'
        puts 'avocado lists                          - show lists'
        puts 'avocado lists create <name>            - create a list called <name>'
        puts 'avocado lists show <index>             - show list at index <index> (this will select the list)'
        puts 'avocado lists delete <index>           - delete list at index <index>'
        puts 'avocado lists items create <item>      - create new item in selected list'
        puts 'avocado lists items complete <index>   - complete item at index <index> in selected list'
        puts 'avocado lists items uncomplete <index> - complete item at index <index> in selected list'
        puts 'avocado lists items delete <index>     - delete item at index <index> in selected list'
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
