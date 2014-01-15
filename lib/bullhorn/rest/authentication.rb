module Bullhorn
module Rest

# http://supportforums.bullhorn.com/viewtopic.php?f=104&t=14542
module Authentication

  def auth_conn
    @auth_conn ||= Faraday.new
  end

  def authorize
    url = "https://auth.bullhornstaffing.com/oauth/authorize"
    params = {
      client_id: client_id,
      username: username,
      password: password,
      action: 'Login',
      response_type: 'code'
    }
    res = auth_conn.get url, params
    location = res.headers['location']

    @auth_code = CGI::parse(URI(location).query)["code"].first
  end


  def retrieve_tokens
    url = "https://auth.bullhornstaffing.com/oauth/token"
    params = {
      grant_type: 'authorization_code',
      code: auth_code,
      client_id: client_id,
      client_secret: client_secret
    }
    res = auth_conn.post url, params
    hash = JSON.parse(res.body)

    @access_token = hash['access_token']
    @access_token_expires_in = hash['expires_in']
    @refresh_token = hash['refresh_token']
  end


  def login
    url = "https://rest.bullhornstaffing.com/rest-services/login"
    params = {
      version: '*',
      access_token: access_token
    }
    response = auth_conn.get url, params
    hash = JSON.parse(response.body)

    @rest_token = hash['BhRestToken']
    @rest_url = hash['restUrl']
  end


  def authenticate
    unless rest_token
      unless access_token
        unless auth_code
          authorize
        end
        retrieve_tokens
      end
      login
    end
  end


  def authenticated?
    # TODO: check expires
    !!rest_token
  end

end

end
end