require 'spec_helper'

describe Bullhorn::Rest::Entities, :vcr do


  def self.entity_spec(name, owner_methods=false, immutable=false)

    describe name do

      plural = name.to_s.pluralize

      it ".#{plural} returns #{plural}" do
        res = client.send plural
        expect(res.status).to eq(200)
      end

      if owner_methods

        it ".department_#{plural} returns #{plural}" do
          res = client.send "department_#{plural}"
          expect(res.status).to eq(200)
        end

        it ".user_#{plural} returns #{plural}" do
          res = client.send "user_#{plural}"
          expect(res.status).to eq(200)
        end

      end

    end

  end

  let(:client) { Bullhorn::Rest::Client.new(client_id: test_bh_client_id, client_secret: test_bh_client_secret, username: test_bh_username, password: test_bh_password) }

  
  entity_spec :appointment
  entity_spec :appointment_attendee
  entity_spec :business_sector
  entity_spec :candidate, true
  entity_spec :candidate_certification
  entity_spec :candidate_education
  entity_spec :candidate_reference
  entity_spec :candidate_work_history
  entity_spec :category, false, true
  entity_spec :client_contact, true
  entity_spec :client_corporation, true
  entity_spec :corporate_user, false, true
  entity_spec :corporation_department
  entity_spec :country, false, true
  entity_spec :custom_action
  entity_spec :job_order, true
  entity_spec :job_submission
  entity_spec :note, true
  entity_spec :note_entity
  entity_spec :placement, true
  entity_spec :placement_change_request
  entity_spec :placement_commission
  entity_spec :sendout
  entity_spec :skill, false, true
  entity_spec :specialty, false, true
  entity_spec :state, false, true
  entity_spec :task
  entity_spec :tearsheet
  entity_spec :tearsheet_recipient
  entity_spec :time_unit, false, true

end