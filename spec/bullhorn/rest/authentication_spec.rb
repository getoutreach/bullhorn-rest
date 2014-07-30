require 'spec_helper'

describe Bullhorn::Rest::Authentication, :vcr do

  let(:default_options) {{client_id: test_bh_client_id, client_secret: test_bh_client_secret}}
  let(:options) {{}}
  let(:client) { Bullhorn::Rest::Client.new(default_options.merge(options)) }


  context 'when username and password set' do

    let(:options) {{username: test_bh_username, password: test_bh_password}}

    it 'authenticates' do

      expect(client.auth_code).to be_nil
      expect(client.access_token).to be_nil
      expect(client.rest_token).to be_nil

      client.authenticate

      expect(client.auth_code).to_not be_nil
      expect(client.access_token).to_not be_nil
      expect(client.rest_token).to_not be_nil

    end

    context 'and ttl parameter set' do

      let(:options) {{username: test_bh_username, password: test_bh_password, ttl: 1000}}

      it 'expires later' do

        client.authenticate
        expect(client.rest_token).to_not be_nil

      end

    end

  end

  context 'when access_token set' do

    let(:options) {
      c = Bullhorn::Rest::Client.new(default_options.merge({username: test_bh_username, password: test_bh_password}))
      c.authenticate
      {access_token: c.access_token}
    }

    it 'authenticates' do 

      expect(client.access_token).to_not be_nil
      expect(client.rest_token).to be_nil

      client.authenticate

      expect(client.access_token).to_not be_nil
      expect(client.rest_token).to_not be_nil

    end

  end

  context 'when rest_token and rest_url set' do
    let(:options) {
      c = Bullhorn::Rest::Client.new(default_options.merge({username: test_bh_username, password: test_bh_password}))
      c.authenticate
      {rest_token: c.rest_token, rest_url: c.rest_url}
    }

    it 'authenticates' do
      expect(client.rest_token).to_not be_nil

      client.authenticate

      expect(client.rest_token).to_not be_nil

    end
  end


  context 'when refresh token set' do
    let(:options) {
      c = Bullhorn::Rest::Client.new(default_options.merge({username: test_bh_username, password: test_bh_password}))
      c.authenticate
      {refresh_token: c.refresh_token}
    }

    it 'authenticates' do
      expect(client.access_token).to be_nil
      expect(client.rest_token).to be_nil

      client.authenticate

      expect(client.access_token).to_not be_nil
      expect(client.rest_token).to_not be_nil

    end
  end


end