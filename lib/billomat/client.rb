#!/usr/bin/env ruby
# encoding: utf-8

class Billomat
  # Public: The clients resource handles all clients.
  #
  # See http://www.billomat.com/en/api/clients/
  class Client < BaseResource
    attr_writer :myself

    def initialize id, data
      super
      @myself = false
    end

    # Public: Fetch information about yourself.
    #
    # Returns a new Client resource.
    def self.myself
      c = get 'clients', 'myself'
      client = new c.client.id, c.client
      client.myself = true
      client
    end

    # Public: Indicates wether this resource is yourself or not.
    #
    # Returns Boolean wether or not this resource is yourself.
    def myself?
      @myself
    end
  end
end
