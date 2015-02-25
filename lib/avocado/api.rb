module Avocado
end

class Avocado::API
  def initialize(auth_client)
    @auth_client = auth_client
    @couple = nil
  end

  def update_from_command_line
    @auth_client.update_from_command_line

    @auth_client.update_signature
    if @auth_client.dev_signature.nil?
      puts $ERROR_MSG
      return
    end

    update_couple
    if @couple.nil?
      puts $ERROR_MSG
    else
      p @couple
      puts "SUCCESS.\n\nBelow is your Avocado API signature:\n#{@auth_client.dev_signature}\n"
    end
  end

  def update_couple
    connection = Net::HTTP::new($AVOCADO_API_HOST, $AVOCADO_API_PORT)
    connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    connection.use_ssl = true
    resp = connection.get($AVOCADO_API_URL_COUPLE, get_signed_headers)
    if resp.code == "200"
      @couple = resp.body
    end
  end

  def get_signed_headers
    return {
      'Cookie' => $AVOCADO_COOKIE_NAME + "=" + @auth_client.cookie,
      'X-AvoSig' => @auth_client.dev_signature,
      'User-Agent' => $AVOCADO_USER_AGENT
    }
  end

  attr_reader :auth_client
end
