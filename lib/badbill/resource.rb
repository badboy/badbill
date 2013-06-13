# encoding: utf-8

class BadBill
  # Forward requests to the underlying connection object.
  #
  # This module is included in BadBill::BaseResource.
  module Resource
    # @param (see BadBill#get)
    def get resource, id='', options=nil
      call resource, id, options, :get
    end

    # @param (see BadBill#post)
    def post resource, id='', options=nil
      call resource, id, options, :post
    end

    # @param (see BadBill#put)
    def put resource, id='', options=nil
      call resource, id, options, :put
    end

    # @param (see BadBill#delete)
    def delete resource, id='', options=nil
      call resource, id, options, :delete
    end

    # @param (see BadBill#call)
    def call resource, id='', options=nil, method=:get
      connection.call resource, id, options, method
    end
  end
end
