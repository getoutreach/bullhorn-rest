require 'active_support/all'
require 'json'
require 'hashie'

module Bullhorn
  module Rest
    module Entities

      # http://developer.bullhorn.com/sites/default/files/BullhornRESTAPI_0.pdf
      module Base
        def entity
          @entity || self.name.demodulize.underscore
        end

        module Decorated_Entity
          def next_page
            start_param = @current_record + record_count + 1

            params = { :fields => '*', :count => record_count, :start => start_param }.merge(@options)
            res = @conn.get @path, params
            json = JSON.parse(res.body)

            obj = Hashie::Mash.new json
            obj.record_count = json['count']
            obj.has_next_page = obj.total? ? ((obj.start + obj.record_count) <= obj.total) : false

            @current_record = @current_record + record_count    
            obj
          end
        end 

        def define_methods(options={})
          name = entity.to_s.classify
          plural = entity.to_s.pluralize
          name_plural = name.pluralize

          if options[:owner_methods]

            define_method("decorate_response") do |res|
              obj = Hashie::Mash.new res
              obj.record_count = res["count"]
              obj.has_next_page = obj.total? ? ((obj.start + obj.record_count) <= obj.total) : false       
              obj  
            end      

            define_method("attach_next_page") do |obj, options, path, conn|
              obj.instance_variable_set :@options, options
              obj.instance_variable_set :@path, path
              obj.instance_variable_set :@current_record, 0
              obj.instance_variable_set :@conn, conn
              obj.instance_eval do class << self; include Decorated_Entity; end; end       
              obj
            end   

            define_method("department_#{plural}") do |options={}|
              params = {:fields => '*', :count => '100'}.merge(options)
              path = "department#{name_plural}"

              res = @conn.get path, params
              obj = decorate_response JSON.parse(res.body)

              attach_next_page obj, options, path, conn
            end                         

            define_method("user_#{plural}") do |options={}|
              params = {:fields => '*', :count => '100'}.merge(options)
              path = "my#{name_plural}"
              res = @conn.get path, params
              obj = decorate_response JSON.parse(res.body)
              attach_next_page obj, options, path, conn
            end

            alias_method plural, "department_#{plural}"
          else
            # Don't see an "all" entities api call. Instead we
            # use a criteria that is always true
            define_method(plural) do |options={}|
              send "query_#{plural}", where: "id IS NOT NULL"
            end
          end

          define_method("search_#{plural}") do |options={}|
            params = {:fields => '*', :count => '500'}.merge(options)
            path = "search/#{name}"
            res = @conn.get path, params
            obj = decorate_response JSON.parse(res.body)
            attach_next_page obj, options, path, conn    
          end

          define_method("query_#{plural}") do |options={}|
            # params = {:fields => '*', :count => '500', :orderBy => 'name'}.merge(options)
            params = {:fields => '*', :count => '500'}.merge(options)
            path = "query/#{name}"
            res = @conn.get path, params
            obj = decorate_response JSON.parse(res.body)
            attach_next_page obj, options, path, conn     
          end

          define_method(entity) do |id, options={}|
            params = {fields: '*'}.merge(options)
            path = "entity/#{name}/#{Array.wrap(id).join(',')}"
            if assoc = options.delete(:association)
              path += "/#{assoc}"
            end
            res = conn.get path, params
            Hashie::Mash.new JSON.parse(res.body)
          end

          unless options[:immutable]

            define_method("create_#{entity}") do |attributes = {}, options={}|
              path = "entity/#{name}"
              if candidate_id = options.delete(:candidate_id)
                path += "/#{candidate_id}"
              end
              if assoc = options.delete(:association)
                path += "/#{assoc}"
              end
              if ids = options.delete(:association_ids)
                path += "/#{ids.to_s}"
              end
              res = conn.put path, attributes
              Hashie::Mash.new JSON.parse(res.body)
            end

            define_method("update_#{entity}") do |id, attributes={}|
              path = "entity/#{name}/#{id}"
              res = conn.post path, attributes
              Hashie::Mash.new JSON.parse(res.body)
            end

            define_method("delete_#{entity}") do |id|
              path = "entity/#{name}/#{id}"
              res = conn.delete path
              Hashie::Mash.new JSON.parse(res.body)
            end
          end

          if options[:file_methods]
            define_method("put_#{entity}_file") do |id, attributes = {}|
              path = "file/#{name}/#{id}"
              res = conn.put path, attributes
              Hashie::Mash.new JSON.parse(res.body)
            end
          end
        end
      end
    end
  end
end