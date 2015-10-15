module Bullhorn
module Rest

# http://supportforums.bullhorn.com/viewtopic.php?f=104&t=14542
module Authentication

  attr_accessor :username, :password, :client_id, :client_secret, :auth_code, :access_token, :access_token_expires_at, :refresh_token, :ttl, :rest_token

  # Allow configuration of auth host
  def auth_host=(host)
    @auth_host = host
  end

  def auth_host
    @auth_host ||= "auth.bullhornstaffing.com"
  end

  # Allow configuration of rest host
  def rest_host=(host)
    @rest_host = host
  end

  def rest_host
    @rest_host ||= "rest.bullhornstaffing.com"
  end


  # Use a separate connection for authentication
  def auth_conn
    @auth_conn ||= Faraday.new
  end

  def authorize
    url = "https://#{self.auth_host}/oauth/authorize"
    params = {
      client_id: client_id,
      username: username,
      password: password,
      action: 'Login',
      response_type: 'code'
    }
    res = auth_conn.get url, params
    location = res.headers['location']
    self.auth_code = CGI::parse(URI(location).query)["code"].first
  end

  def retrieve_tokens
    url = "https://#{self.auth_host}/oauth/token"
    params = {
      grant_type: 'authorization_code',
      code: auth_code,
      client_id: client_id,
      client_secret: client_secret
    }
    res = auth_conn.post url, params
    hash = JSON.parse(res.body)

    self.access_token = hash['access_token']
    self.access_token_expires_at = hash['expires_in'].to_i.seconds.from_now
    self.refresh_token = hash['refresh_token']
  end

  def refresh_tokens
    url = "https://#{self.auth_host}/oauth/token"
    params = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token,
      client_id: client_id,
      client_secret: client_secret
    }
    res = auth_conn.post url, params
    hash = JSON.parse(res.body)

    self.access_token = hash['access_token']
    self.access_token_expires_at = hash['expires_in'].to_i.seconds.from_now
    self.refresh_token = hash['refresh_token']
  end

  def login
    url = "https://#{self.rest_host}/rest-services/login"
    params = {
      version: '*',
      access_token: access_token
    }
    params[:ttl] = ttl if ttl
    response = auth_conn.get url, params
    hash = JSON.parse(response.body)

    self.rest_token = hash['BhRestToken']
    self.rest_url = hash['restUrl']
  end

  def authenticate
    expire if expired?
    unless rest_token
      unless access_token
        if refresh_token
          refresh_tokens
        else
          unless auth_code
            authorize
          end
          retrieve_tokens
        end
      end
      login
    end
    did_authenticate
  end

  def rest_url=(url)
    @rest_url = URI(url)
  end

  def rest_url
    @rest_url
  end

  def authenticated?
    rest_token && !expired?
  end

  def expired?
    access_token_expires_at && access_token_expires_at < Time.now
  end

  def expire
    self.access_token = nil
    self.access_token_expires_at = nil
    self.rest_token = nil
  end

  # Callback that can be overridden
  def did_authenticate
  end

  # Makes sure the client is authenticated
  class Middleware

    def initialize(app, client)
      @app = app
      @client = client
    end

    def call(env)

      @client.authenticate unless @client.authenticated?

      rebuild_url(env[:url])

      request_body = env[:body]
      res = @app.call(env)

      if env[:status] == 401
        @client.expire
        @client.authenticate
        env[:body] = request_body # after failure env[:body] is set to the response body
        res = @app.call(env)
      end

      res
      
    end

    # Add rest url and token to the url
    def rebuild_url(url)
      url.host = @client.rest_url.host
      url.port = @client.rest_url.port
      url.scheme = @client.rest_url.scheme
      url.path = File.join(@client.rest_url.path, url.path)
      query = url.query ? CGI::parse(url.query) : {}
      query[:BhRestToken] = @client.rest_token
      url.query = URI.encode_www_form(query)
    end

  end

end

end
end