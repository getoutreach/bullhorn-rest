require 'spec_helper'
require 'bullhorn/rest/entities/resume'
require 'bullhorn/rest'


describe Bullhorn::Rest::Entities::Resume do

  let(:client) { Bullhorn::Rest::Client.new(client_id: test_bh_client_id, client_secret: test_bh_client_secret, username: test_bh_username, password: test_bh_password) }

  
  describe "candidate parser" do 
    it "should return a Work History from cv text" do 
      #Needs refeactoring to work with current VCR Setup
      #candidate = client.candidate(7826)
      #puts candidate
      #res = client.parse_to_candidate(candidate["data"]["description"])
      #puts res
      #expect(res["candidateWorkHistory"][0]["companyName"]).to_not be_nil

    end
  end
  

end