require 'active_support/all'

module Bullhorn
module Rest
module Entities

# http://developer.bullhorn.com/sites/default/files/BullhornRESTAPI_0.pdf
module Base

  def entity
    @entity || self.name.demodulize.underscore
  end

  def define_methods(options={})
    name = entity.to_s.classify
    plural = entity.to_s.pluralize
    name_plural = name.pluralize


    if options[:owner_methods]
      define_method("department_#{plural}") do |options={}|
        params = {fields: '*'}.merge(options)
        path = "department#{name_plural}"
        conn.get path, params
      end

      define_method("user_#{plural}") do |options={}|
        params = {fields: '*'}.merge(options)
        path = "my#{name_plural}"
        conn.get path, params
      end

      alias_method plural, "department_#{plural}"
    else
      # Don't see an "all" entities api call. Instead we
      # use a criteria that is always true
      define_method(plural) do |options={}|
        send "query_#{plural}", where: "id IS NOT NULL"
      end
    end

    define_method("query_#{plural}") do |options={}|
      params = {fields: '*'}.merge(options)
      path = "query/#{name}"
      conn.get path, params
    end

    unless options[:immutable]

      define_method("create_#{entity}") do |id, attributes={}|
        path = "#{name}/#{id}"
        conn.put path, attributes
      end

      define_method("update_#{entity}") do |id, attributes={}|
        path = "#{name}/#{id}"
        conn.post path, attributes
      end

      define_method("delete_#{entity}") do |id|
        path = "#{name}/#{id}"
        conn.delete path
      end

    end

  end

end

end
end
end