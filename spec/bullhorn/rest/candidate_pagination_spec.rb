require 'spec_helper'
require 'bullhorn/rest/entities/resume'
require 'bullhorn/rest'


describe Bullhorn::Rest::Entities::Candidate, :vcr do

  let(:client) { Bullhorn::Rest::Client.new(client_id: test_bh_client_id, client_secret: test_bh_client_secret, username: test_bh_username, password: test_bh_password) }

  describe "pagination" do 


    it "should move to next page if there is one" do 
      res = client.candidates 
      page_2 = res.next_page

      #puts "total:" + page_2.total.to_s
      #puts "start:" + page_2.start.to_s
      #puts "record_count:" + page_2.record_count.to_s

      expect(page_2.start).to eq(101)      
      expect(page_2.record_count).to eq(100)

      page_3 = res.next_page

      expect(page_3.start).to eq(201)      
      expect(page_3.record_count).to eq(100)

      page_4 = res.next_page

      expect(page_4.start).to eq(301)      
      expect(page_4.record_count).to eq(100)      

    end


    it "should return correct totals when initialized" do 
      res = client.candidates

      #expect(res.total).to eq(13292)
      expect(res.start).to eq(0)
      expect(res.record_count).to eq(100)
    end
  

    it "should return results paged by options " do 
      res = client.candidates

      expect(res.start).to eq(0)
      expect(res.record_count).to eq(100)  
      #puts "resrecord_count:" + res.record_count.to_s   
    end

    it "should return next page if there is one" do 
      res = client.candidates
    
      expect(res.has_next_page?).to be true
    end


  end
  

end