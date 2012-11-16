# encoding: utf-8

class BadBill
  class BaseResource
    include BadBill::Resource
    extend BadBill::Resource

    include BadBill::ForwardMethods

    # ID of the resource.
    attr_reader   :id
    # All data in a Hash.
    attr_accessor :data

    # Public: Create new resource object.
    #
    # @param [String,Integer] id The ID of the resource.
    # @param [Hashie::Mash] data Resource data.
    #
    # All resources have an ID and data. Methods are proxied to the data object.
    #
    # @return [Resource] A new resource.
    def initialize id, data
      @id   = id
      @data = data
    end

    # Get all resources of this type.
    #
    # @param [Hash] filter An Hash of filter parameters,
    #                      see the online documentation for allowed values.
    #
    # @return [Array<Resource>] All found resources.
    def self.all filter={}
      all = get resource_name, filter
      return all if all.error

      resources = all.__send__(resource_name)
      case resources['@total'].to_i
      when 0
        []
      when 1
        data = resources.__send__(resource_name_singular)
        [new(data.id.to_i, data)]
      else
        resources.__send__(resource_name_singular).map do |res|
          new res.id.to_i, res
        end
      end
    end

    # Get the resource with the given ID.
    #
    # @param [String,Integer] id ID of the resource.
    #
    # @return [Resource] New resource with id and data set.
    def self.find id
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
      new id, data
    end

    # Create a new resource with the given parameters.
    #
    # @param [Hash] params A Hash-like object of data.
    #                      See the online documentation for allowed values.
    #
    # @return [Resource] New resource with id and data set.
    def self.create params
      res = post(resource_name, {resource_name_singular => params})
      return res if res.error

      res_data = res.__send__(resource_name_singular)
      new res_data.id.to_i, res_data
    end

    # Save any changed data.
    #
    # @return [Boolean] True if successfull, false otherwise.
    def save
      @data.id = id
      res = put resource_name, id, {resource_name_singular => @data}

      return res if res.error

      res_data = res.__send__(resource_name_singular)
      @data = res_data
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

    # Protect overriding of the ID.
    #
    # @raise [NoMethodError] because the ID may not be overwritten.
    def id= *args
      raise NoMethodError, "undefined method `id=' for '#{self.inspect.sub(/ .+/, '>')}`"
    end

    def error
      if @data.respond_to?(:error)
        @data.error
      else
        nil
      end
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
