# encoding: utf-8

class Billomat
  # Forward requests to the underlying connection object.
  #
  # This module is included in Billomat::BaseResource.
  module Resource
    # @param (see Billomat#get)
    def get resource, id='', options=nil
      call resource, id, options, :get
    end

    # @param (see Billomat#post)
    def post resource, id='', options=nil
      call resource, id, options, :post
    end

    # @param (see Billomat#put)
    def put resource, id='', options=nil
      call resource, id, options, :put
    end

    # @param (see Billomat#delete)
    def delete resource, id='', options=nil
      call resource, id, options, :delete
    end

    # @param (see Billomat#call)
    def call resource, id='', options=nil, method=:get
      raise Billomat::NoConnection, "No connection. Use Billomat.new first." if Billomat.connection.nil?
      Billomat.connection.call resource, id, options, method
    end
  end
end
