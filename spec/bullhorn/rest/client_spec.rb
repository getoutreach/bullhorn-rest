require 'spec_helper'

describe Bullhorn::Rest::Client, :vcr do

  let(:options) {{}}
  let(:client) { Bullhorn::Rest::Client.new({client_id: test_bh_client_id, client_secret: test_bh_client_secret}.merge(options)) }

  describe 'authentication' do

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

    end

  end

end