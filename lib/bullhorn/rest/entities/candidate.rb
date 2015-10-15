module Bullhorn
  module Rest
    module Entities
      module Candidate
        extend Base

        define_methods(owner_methods: true, file_methods: true)
      end
    end
  end
end