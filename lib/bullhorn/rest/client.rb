require 'faraday'

require 'bullhorn/rest/authentication'

module Bullhorn
module Rest

class Client

  include Bullhorn::Rest::Authentication

  attr_reader :username, :password, :client_id, :client_secret, :auth_code, :access_token, :rest_token, :rest_url, :refresh_token

  # Initializes a new Bullhorn REST Client
  def initialize(options = {})

    @username = options[:username]
    @password = options[:password]
    @client_id = options[:client_id]
    @client_secret = options[:client_secret]
    @auth_code = options[:auth_code]
    @rest_url = options[:rest_url]
    @rest_token = options[:rest_token]
    @access_token = options[:access_token]
    @refresh_token = options[:refresh_token]

  end

  def conn
    @conn ||= Faraday.new(url: rest_url)
  end

end

end
end