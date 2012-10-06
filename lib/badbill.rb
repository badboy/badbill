# encoding: utf-8
#
# Copyright (c) 2012 Jan-Erik Rediger <jer@rrbone.net>
# See LICENSE for info.
# Developed for internal use at rrbone (http://www.rrbone.net)

require 'yajl/json_gem'
require 'faraday_middleware'
require 'hashie/mash'

require_relative 'badbill/resource'
require_relative 'badbill/forward_methods'
require_relative 'badbill/base_resource'

require_relative 'badbill/client'
require_relative 'badbill/invoice'
require_relative 'badbill/invoice_payment'
require_relative 'badbill/invoice_item'
require_relative 'badbill/recurring'

# Handles the connection and requests to the Billomat API.
#
# This class can be used for direct API access and is used for connections from
# resource classes.
#
# If a API resource is not yet implemented as a Ruby class, easy access is possible here.
#
# Examples:
#
#     billo = BadBill.new 'ruby', '1234568'
#     # => #<BadBill:0x00000002825710     ...>
#     billo.get 'clients'
#     # => {"clients"=>{"client"=>[...]}}
class BadBill
  VERSION = '0.0.2'

  # Reject any not allowed HTTP method.
  class NotAllowedException < Exception; end
  # Fail if no global connection is set.
  class NoConnection < Exception; end

  # The API url used for all connections.
  API_URL = 'http%s://%s.billomat.net/'
  # Allowed HTTP methods.
  ALLOWED_METHODS = [:get, :post, :put, :delete]

  # Create new Billomat connection.
  #
  # @param [String] billomat_id Used as your BillomatID
  # @param [String] api_key     API Key used to authenticate to the API.
  # @param [Boolean] ssl        Wether to use SSL or not (only possible for paying customers)
  def initialize billomat_id, api_key, ssl=false
    @billomat_id  = billomat_id
    @api_key      = api_key
    @ssl          = ssl
    @http_adapter = connection

    BadBill.connection = self
  end

  # Assign global BadBill connection object.
  #
  # @param [BadBill] connection The connection object.
  def self.connection= connection
    @connection = connection
  end

  # Get the global connection object.
  #
  # @return [BadBill, nil] The global connection object or nil if not set.
  def self.connection
    @connection
  end

  # Call the specified resource.
  #
  # It sets the X-BillomatApiKey header, the Content-Type header and the Accept header.
  #
  # @param [String] resource    The String resource name (gets prepended with _/api/_).
  # @param [String,Integer] id  The ID for the resource.
  # @param [Hash] options       All parameters for this request.
  #                             Exact parameters depend on the resource.
  # @param [Symbol] method      One of ALLOWED_METHODS.
  #
  # @return [Hashie::Mash] The response body.
  #                        On error the return value only includes the key :error.
  def call resource, id='', options=nil, method=:get
    raise NotAllowedException.new("#{method.inspect} is not allowed. Use one of [:#{ALLOWED_METHODS*', :'}]") unless ALLOWED_METHODS.include?(method)

    if id.kind_of? Hash
      options = id
      id = ''
    end

    #no_accept = options.delete :no_accept
    @http_adapter.__send__(method) { |req|
      if method == :get && options && !options.empty?
        req.url "/api/#{resource}/#{id}", options
      else
        req.url "/api/#{resource}/#{id}"
      end
      req.headers['X-BillomatApiKey'] = @api_key
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json' if [:post, :put].include?(method)
      req.body = options if method != :get && options && !options.empty?
    }.body
  rescue Faraday::Error::ClientError => error
    Hashie::Mash.new :error => error
  end

  # Send a GET request.
  #
  # @param (see #call)
  # @return (see #call)
  def get resource, id='', options=nil
    call resource, id, options, :get
  end

  # Send a POST request.
  #
  # @param (see #call)
  # @return (see #call)
  def post resource, id='', options=nil
    call resource, id, options, :post
  end

  # Send a PUT request.
  #
  # @param (see #call)
  # @return (see #call)
  def put resource, id='', options=nil
    call resource, id, options, :put
  end

  # Send a DELETE request.
  #
  # @param (see #call)
  # @return (see #call)
  def delete resource, id='', options=nil
    call resource, id, options, :delete
  end

  private
  # Creates a new Faraday connection object.
  #
  # @return [Faraday] new connection object with url and response handling set.
  def connection
    @connection ||= Faraday.new(API_URL % [@ssl ? 's' : '', @billomat_id]) do |conn|
      conn.request :json

      conn.response :mashify
      conn.response :json, :content_type => /\bjson$/
      #conn.response :logger
      conn.response :raise_error
      conn.adapter  :net_http
      conn.options[:timeout] = 2
    end
  end
end
