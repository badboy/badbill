# encoding: utf-8

class Billomat
  class BaseResource
    include Billomat::Resource
    extend Billomat::Resource

    include Billomat::ForwardMethods

    attr_reader   :id
    attr_accessor :data

    # Public: Create new resource object.
    #
    # id   - The String or Integer ID of the resource.
    # data - A Hash-like object of data.
    #
    # All resources have an ID and data. Methods are proxied to the data object.
    #
    # Returns a new resource.
    def initialize id, data
      @id   = id
      @data = data
    end

    # Public: Get all resources of this type.
    #
    # filter - An Hash of filter parameters,
    #          see the online documentation for allowed values.
    #
    # Returns an Array of new resources.
    def self.all filter={}
      all = get resource_name, filter
      all.__send__(resource_name).__send__(resource_name_singular).map do |res|
        new res.id, res
      end
    end

    # Public: Get the resource with the given ID.
    #
    # id - The String or Integer ID of the resource.
    #
    # Returns a new resource.
    def self.find id
      c = get resource_name, id
      new id, c.__send__(resource_name)
    end

    # Public: Create a new resource with the given parameters.
    #
    # params - A Hash-like object of data.
    #          See the online documentation for allowed values.
    def self.create params
      res = post(resource_name, {resource_name_singular => params})
      res_data = res.__send__(resource_name_singular)
      new res.data.id, res_data
    end

    # Public: Save any changed data.
    #
    def save
      @data.id = id
      put resource_name, id, {resource_name_singular => @data}
    end

    # Public: Delete this resource.
    def delete
      delete resource_name, id
    end

    # Public: Protect overriding of the ID.
    #
    # Raises a NoMethodError because the ID may not be overwritten.
    def id= *args
      raise NoMethodError, "undefined method `id=' for '#{self.inspect.sub(/ .+/, '>')}`"
    end

    private

    def resource_name_singular
      self.class.resource_name_singular
    end

    def resource_name
      self.class.resource_name
    end

    # Private: The singular resource name for use with the API.
    #
    # By default this is just the Class name, but it may be overridden.
    # Make sure to overwrite resource_name, too.
    #
    # Returns the singular String resource name.
    def self.resource_name_singular
      @resource_name_singular ||= self.name.split(/::/).last.downcase
    end

    # Private: The resource name (plural) for use with the API.
    #
    # By default this is just the `resource_name_singular` with an appended 's'
    # See #resource_name_singular
    #
    # Returns the String resource name.
    def self.resource_name
      @resource_name ||= "#{resource_name_singular}s"
    end
  end
end
