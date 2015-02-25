require 'cgi'
require 'digest'
require 'net/http'
require 'net/https'

module Avocado
  def self.Auth(*argv)
    Avocado::Auth.new(*argv)
  end
end

class Avocado::Auth
  AVOCADO_API_HOST = 'avocado.io'
  AVOCADO_API_PORT = 443
  AVOCADO_API_URL_LOGIN = '/api/authentication/login'
  AVOCADO_COOKIE_NAME = 'user_email'

  attr_reader :config, :dev_id, :dev_key

  def initialize config
    @config = config
    @dev_id = config[:dev_id]
    @dev_key = config[:dev_key]
  end

  def cookie
    @cookie ||= get_cookie_from_login
  end

  def signature
    @signature ||= update_signature
  end

  private

  def get_cookie_from_login
    connection = Net::HTTP::new(AVOCADO_API_HOST, AVOCADO_API_PORT)
    connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    connection.use_ssl = true

    params = "email=#{CGI.escape config[:email]}&password=#{CGI.escape config[:password]}"
    response, data = connection.post AVOCADO_API_URL_LOGIN, params, {}

    if response.code != "200"
      nil
    else
      get_cookie_from_response response, AVOCADO_COOKIE_NAME
    end
  end

  def get_cookie_from_response resp, cookie_name
    all_cookies = resp.get_fields('Set-cookie')
    all_cookies.each { | cookie |
        cookie_string = cookie.split('; ')[0]
        cookie_parts = cookie_string.split('=', 2)
        if cookie_parts[0] == cookie_name
          return cookie_parts[1]
        end
    }
    return nil
  end

  def update_signature
    if cookie.nil?
      puts "The cookie is missing. Login must have failed."
      return
    end

    # Hash the user token.
    hashed_user_token = Digest::SHA256.new << @cookie + @dev_key

    # Get their signature.
    "#{@dev_id}:#{hashed_user_token}"
  end
end
