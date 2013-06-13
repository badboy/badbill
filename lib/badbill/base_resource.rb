# encoding: utf-8

class BadBill
  # A abstract base resource from which all real resources inherit.
  class BaseResource
    include BadBill::Resource

    include BadBill::ForwardMethods

    # ID of the resource.
    attr_accessor :id
    # All data in a Hash.
    attr_accessor :data

    # Public: Create new resource object.
    #
    # @param [BadBill] connection The connection to use.
    #
    # @return [Resource] A new resource.
    def initialize connection
      @__connection__ = connection
    end

    # TODO: should be private?
    # Public: Create a new resource object with id and data and inherit the connection
    #
    # @param [String,Integer] id The ID of the resource
    # @param [Hashie::Mash] data Resource data
    #
    # @return [Resource] A new resource.
    def new_with_data id, data
      obj      = self.class.new @__connection__
      obj.id   = id
      obj.data = data

      obj
    end

    # Get the connection object for this resource.
    #
    # @return [BadBill] The connection object.
    def connection
      @__connection__
    end

    # Get all resources of this type.
    #
    # @param [Hash] filter An Hash of filter parameters,
    #                      see the online documentation for allowed values.
    #
    # @return [Array<Resource>] All found resources.
    def all filter={}
      all = get resource_name, filter
      return all if all.error

      resources = all.__send__(resource_name)
      case resources['@total'].to_i
      when 0
        []
      when 1
        data = resources.__send__(resource_name_singular)
        [new_with_data(data.id.to_i, data)]
      else
        resources.__send__(resource_name_singular).map do |res|
          new_with_data res.id.to_i, res
        end
      end
    end

    # Get the resource with the given ID.
    #
    # @param [String,Integer] id ID of the resource.
    #
    # @return [Resource] New resource with id and data set.
    def find id
      c = get resource_name, id
      if c.error
        if c.error.kind_of? Faraday::Error::ResourceNotFound
          return nil
        else
          return c
        end
      end

      data = c.__send__(resource_name_singular)
      return nil if data.nil?
      new_with_data id, data
    end

    # Create a new resource with the given parameters.
    #
    # @param [Hash] params A Hash-like object of data.
    #                      See the online documentation for allowed values.
    #
    # @return [Resource] New resource with id and data set.
    def create params
      res = post(resource_name, {resource_name_singular => params})
      return res if res.error

      res_data = res.__send__(resource_name_singular)
      new_with_data res_data.id.to_i, res_data
    end

    # Save any changed data.
    #
    # @return [Resource] The instance with changed values or the error object.
    def save
      # Only save
      if @__mutated__ && !@__mutated__.empty?
        data = Hash[@__mutated__.map { |k| [k, @data[k]] }]

        res = put resource_name, id, {resource_name_singular => data}

        return res if res.error

        res_data = res.__send__(resource_name_singular)
        @data.merge!(res_data)
        @__mutated__.clear
      end

      self
    end

    # Delete this resource.
    #
    # @return [Boolean] True if successfull, false otherwise.
    def delete
      # Hack: We can't call #delete here, because we ARE #delete
      resp = call resource_name, id, nil, :delete
      !resp
    end

    # Return the error if any.
    #
    # @return [nil, Error] The error returned from the API
    def error
      if @data.respond_to?(:error)
        @data.error
      else
        nil
      end
    end

    # Inspect this resource
    #
    # @return [String] A stringified short version of important information.
    def inspect
      "<#{self.class.name}:0x#{__id__.to_s(16).rjust(14, '0')} @id=#{id.inspect} @data=#{data.inspect}>"
    end

    private

    def resource_name_singular
      self.class.resource_name_singular
    end

    def resource_name
      self.class.resource_name
    end

    # The singular resource name for use with the API.
    #
    # By default this is just the Class name, but it may be overridden.
    # Make sure to overwrite resource_name, too.
    #
    # @return [String] The singular resource name.
    def self.resource_name_singular
      @resource_name_singular ||= self.name.split(/::/).last.split(/^|([A-Z][a-z]+)/).join('-').downcase
    end

    # The resource name (plural) for use with the API.
    #
    # By default this is just the `resource_name_singular` with an appended 's'
    # See #resource_name_singular
    #
    # @return [String] The resource name.
    def self.resource_name
      @resource_name ||= "#{resource_name_singular}s"
    end
  end
end
