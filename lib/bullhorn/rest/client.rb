require 'faraday'

require 'bullhorn/rest/authentication'

require 'bullhorn/rest/entities/base'
Dir[File.dirname(__FILE__) + '/entities/*.rb'].each {|file| require file }

module Bullhorn
module Rest

class Client

  include Bullhorn::Rest::Authentication
  include Bullhorn::Rest::Entities::Appointment
  include Bullhorn::Rest::Entities::AppointmentAttendee
  include Bullhorn::Rest::Entities::BusinessSector
  include Bullhorn::Rest::Entities::Candidate
  include Bullhorn::Rest::Entities::CandidateCertification
  include Bullhorn::Rest::Entities::CandidateEducation
  include Bullhorn::Rest::Entities::CandidateReference
  include Bullhorn::Rest::Entities::CandidateWorkHistory
  include Bullhorn::Rest::Entities::Category
  include Bullhorn::Rest::Entities::ClientContact
  include Bullhorn::Rest::Entities::ClientCorporation
  include Bullhorn::Rest::Entities::CorporateUser
  include Bullhorn::Rest::Entities::CorporationDepartment
  include Bullhorn::Rest::Entities::Country
  include Bullhorn::Rest::Entities::CustomAction
  include Bullhorn::Rest::Entities::JobOrder
  include Bullhorn::Rest::Entities::JobSubmission
  include Bullhorn::Rest::Entities::Note
  include Bullhorn::Rest::Entities::NoteEntity
  include Bullhorn::Rest::Entities::Placement
  include Bullhorn::Rest::Entities::PlacementChangeRequest
  include Bullhorn::Rest::Entities::PlacementCommission
  include Bullhorn::Rest::Entities::Sendout
  include Bullhorn::Rest::Entities::Skill
  include Bullhorn::Rest::Entities::Specialty
  include Bullhorn::Rest::Entities::State
  include Bullhorn::Rest::Entities::Task
  include Bullhorn::Rest::Entities::Tearsheet
  include Bullhorn::Rest::Entities::TearsheetRecipient
  include Bullhorn::Rest::Entities::TimeUnit

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
    if !authenticated?
      authenticate
    end

    params = {
      BhRestToken: rest_token
    }

    @conn ||= Faraday.new(url: rest_url, params: params)
  end

end

end
end