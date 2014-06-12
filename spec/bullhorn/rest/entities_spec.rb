require 'spec_helper'

describe Bullhorn::Rest::Entities, :vcr do


  def self.describe_entity(name, owner_methods=false, immutable=false, &block)

    describe name do

      plural = name.to_s.pluralize

      it ".#{plural} returns #{plural}" do
        res = client.send plural
        expect(res['data']).to_not be_nil
      end

      if owner_methods

        it ".department_#{plural} returns #{plural}" do
          res = client.send "department_#{plural}"
          expect(res['data']).to_not be_nil
        end

        it ".user_#{plural} returns #{plural}" do
          res = client.send "user_#{plural}"
          expect(res['data']).to_not be_nil
        end

      end

      yield block if block

    end

  end

  let(:client) { Bullhorn::Rest::Client.new(client_id: test_bh_client_id, client_secret: test_bh_client_secret, username: test_bh_username, password: test_bh_password) }
  
  describe_entity :appointment
  describe_entity :appointment_attendee
  describe_entity :business_sector
  describe_entity :candidate, true
  describe_entity :candidate_certification
  describe_entity :candidate_education
  describe_entity :candidate_reference
  describe_entity :candidate_work_history
  describe_entity :category, false, true
  describe_entity :client_contact, true
  describe_entity :client_corporation, true
  describe_entity :corporate_user, false, true
  describe_entity :corporation_department
  describe_entity :country, false, true
  describe_entity :custom_action
  describe_entity :job_order, true
  describe_entity :job_submission
  describe_entity :note, true
  describe_entity :note_entity
  describe_entity :placement, true
  describe_entity :placement_change_request
  describe_entity :placement_commission
  describe_entity :sendout
  describe_entity :skill, false, true
  describe_entity :specialty, false, true
  describe_entity :state, false, true
  describe_entity :task
  describe_entity :tearsheet do

    before do
      tearsheets = client.tearsheets
      @tearsheet_id = tearsheets['data'][0]['id']
    end

    it 'can load specific tearsheet' do
      res = client.tearsheet(@tearsheet_id)
      expect(res['data']).to_not be_nil
    end

    it 'can load candidates association'  do
      res = client.tearsheet(@tearsheet_id, :association => 'candidates')
      expect(res['data'][0]['candidateID']).to_not be_nil
    end

  end
  describe_entity :tearsheet_recipient
  describe_entity :time_unit, false, true


end