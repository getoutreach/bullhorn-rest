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
  include Bullhorn::Rest::Entities::Resume
  include Bullhorn::Rest::Entities::Sendout
  include Bullhorn::Rest::Entities::Skill
  include Bullhorn::Rest::Entities::Specialty
  include Bullhorn::Rest::Entities::State
  include Bullhorn::Rest::Entities::Task
  include Bullhorn::Rest::Entities::Tearsheet
  include Bullhorn::Rest::Entities::TearsheetRecipient
  include Bullhorn::Rest::Entities::TimeUnit


  attr_reader :conn

  # Initializes a new Bullhorn REST Client
  def initialize(options = {})

    @conn = Faraday.new do |f|
      f.use Middleware, self
      f.response :logger
      f.request :multipart
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end

    [:username, :password, :client_id, :client_secret, :auth_code, :access_token, :refresh_token, :ttl, :rest_url, :rest_token, :auth_host, :rest_host].each do |opt|
      self.send "#{opt}=", options[opt] if options[opt]
    end

  end

  def parse_to_candidate(resume_text)
      path = "resume/parseToCandidateViaJson?format=text"
      encodedResume = {"resume" => resume_text}.to_json   
      res = conn.post path, encodedResume

     JSON.parse(res.body)
  end 

  def parse_to_candidate_as_file(format, pop, attributes)
      path = "resume/parseToCandidate?format=#{format}&populateDescription=#{pop}" 
      attributes['file'] = Faraday::UploadIO.new(attributes['file'], attributes['ct'])
      res = conn.post path, attributes
     JSON.parse(res.body)
  end 


end

end
end