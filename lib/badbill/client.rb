# encoding: utf-8

class BadBill
  # The clients resource handles all clients.
  #
  # See http://www.billomat.com/en/api/clients/
  class Client < BaseResource
    attr_writer :myself

    def initialize id, data
      super
      @myself = false
    end

    # Fetch information about yourself.
    #
    # @return [Client] A new resource.
    def self.myself
      c = get 'clients', 'myself'
      client = new c.client.id.to_i, c.client
      client.myself = true
      client
    end

    # Indicates wether this resource is yourself or not.
    #
    # @return [Boolean] Wether or not this resource is yourself.
    def myself?
      @myself
    end
  end
end
