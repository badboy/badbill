# encoding: utf-8

class Billomat
  # Public: Forward requests to the underlying connection object.
  #
  # This module is included in Billomat::BaseResource.
  module Resource
    # See Billomat#get
    def get resource, id='', options=nil
      call resource, id, options, :get
    end

    # See Billomat#post
    def post resource, id='', options=nil
      call resource, id, options, :post
    end

    # See Billomat#put
    def put resource, id='', options=nil
      call resource, id, options, :put
    end

    # See Billomat#delete
    def delete resource, id='', options=nil
      call resource, id, options, :delete
    end

    # See Billomat#call
    def call resource, id='', options=nil, method=:get
      raise Billomat::NoConnection, "No connection. Use Billomat.new first." if Billomat.connection.nil?
      Billomat.connection.call resource, id, options, method
    end
  end
end
