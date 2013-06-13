# encoding: utf-8

class BadBill
  # The clients resource handles all clients.
  #
  # See http://www.billomat.com/en/api/clients/
  class Client < BaseResource
    attr_writer :myself

    def initialize connection
      super
      @myself = false
    end

    # Fetch information about yourself.
    #
    # @return [Client] A new resource.
    def myself
      c = get 'clients', 'myself'
      client = new_with_data c.client.id.to_i, c.client
      client.myself = true
      client
    end

    # Indicates wether this resource is yourself or not.
    #
    # @return [Boolean] Whether or not this resource is yourself.
    def myself?
      @myself
    end
  end
end
