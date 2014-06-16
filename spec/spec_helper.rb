require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
$:.unshift File.dirname(__FILE__)

require 'rspec'
require 'webmock/rspec'
require 'bullhorn/rest'
require 'byebug'
require 'pry'
require 'maybe'

RSpec.configure do |config|

end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("BULLHORN_USERNAME") do
    test_bh_username
  end
  c.filter_sensitive_data("BULLHORN_PASSWORD") do
    test_bh_password
  end
  c.filter_sensitive_data("BULLHORN_CLIENT_ID") do
    test_bh_client_id
  end
  c.filter_sensitive_data("BULLHORN_CLIENT_SECRET") do
    test_bh_client_secret
  end

    c.filter_sensitive_data("BULLHORN_AUTH_CODE") do |interaction|
      location = Maybe(interaction).response.headers["Location"].first.__value__
      if(location && m = location.match(/\?code=(.+)/))
        m[1]
      end
    end
    c.filter_sensitive_data("BULLHORN_REFRESH_TOKEN") do |interaction|
      hash = JSON.parse(interaction.response.body) rescue nil
      hash && hash['refresh_token']
    end
    c.filter_sensitive_data("BULLHORN_ACCESS_TOKEN") do |interaction|
      hash = JSON.parse(interaction.response.body) rescue nil
      hash && hash['access_token'] || CGI::parse(URI(interaction.request.uri).query)['access_token'].first rescue nil
    end
    c.filter_sensitive_data("BULLHORN_SESSION_TOKEN") do |interaction|
      hash = JSON.parse(interaction.response.body) rescue nil
      hash && hash['BhRestToken']
    end
    c.default_cassette_options = {
      :serialize_with             => :json,
      # TODO: Track down UTF-8 issue and remove
      :preserve_exact_body_bytes  => true,
      :decode_compressed_response => true,
      :match_requests_on => [:method, :host, :path],  
    }
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock

  
  c.allow_http_connections_when_no_cassette = true
end


def test_bh_username
  ENV.fetch 'BH_TEST_USERNAME', 'bh_username'
end

def test_bh_password
  ENV.fetch 'BH_TEST_PASSWORD', 'bh_password'
end

def test_bh_client_id
  ENV.fetch 'BH_TEST_CLIENT_ID', 'bh_client_id'
end

def test_bh_client_secret
  ENV.fetch 'BH_TEST_CLIENT_SECRET', 'bh_client_secret'
end