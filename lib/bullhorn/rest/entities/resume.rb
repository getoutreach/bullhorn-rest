module Bullhorn
module Rest
module Entities

module Resume
  extend Base

  def parse_to_candidate(resume_text)
  	 path = "resume/parseToCandidateViaJson?format=text&populateDescription=text"
  		encodedResume = '{ 
     	"resume" => resume_text
    	} '  	 
     res = conn.post path, resume_text
     JSON.parse(res.body)
  end 
end

end
end
end