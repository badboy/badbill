# encoding: utf-8

require 'yajl/json_gem'
require 'faraday_middleware'
require 'hashie/mash'

require_relative 'billomat/resource'
require_relative 'billomat/forward_methods'
require_relative 'billomat/base_resource'

require_relative 'billomat/client'
require_relative 'billomat/invoice'

# Public: Handles the connection and requests to the Billomat API.
#
# This class can be used for direct API access and is used for connections from
# resource classes.
#
# If a API resource is not yet implemented as a Ruby class, easy access is possible here.
#
# Examples:
#
#     billo = Billomat.new 'ruby', '1234568' => #<Billomat:0x00000002825710
#     ...> billo.get 'clients' => {"clients"=>{"client"=>[...]}}
class Billomat
  class NotAllowedException < Exception; end
  class NoConnection < Exception; end

  API_URL = 'http%s://%s.billomat.net/'
  ALLOWED_METHODS = [:get, :post, :put, :delete]

  # Public: Create new Billomat connection.
  #
  # billomat_id - The String used as your BillomatID
  # api_key     - The String key to authenticate to the API.
  # ssl         - Wether to use SSL or not (only possible for paying customers, default: false)
  def initialize billomat_id, api_key, ssl=false
    @billomat_id  = billomat_id
    @api_key      = api_key
    @ssl          = ssl
    @http_adapter = connection

    Billomat.connection = self
  end

  # Private: assign global Billomat connection object.
  def self.connection= connection
    @connection = connection
  end

  def self.connection
    @connection
  end

  # Public: Call the specified resource.
  #
  # resource - The String resource name (gets prepended with /api/).
  # id       - The ID for the resource (may be a String or an Integer, default: '').
  # options  - A Hash containing all parameters for this request (default: nil).
  #            Exact parameters depend on the resource.
  # method   - One of ALLOWED_METHODS (default: :get).
  #
  # It sets the X-BillomatApiKey header, the Content-Type header and the Accept header.
  #
  # Returns the response body as a Hashie::Mash.
  # On error the return value only includes the key :error.
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

  # Public: Send a GET request.
  #
  # See #call for arguments.
  def get resource, id='', options=nil
    call resource, id, options, :get
  end

  # Public: Send a POST request.
  #
  # See #call for arguments.
  def post resource, id='', options=nil
    call resource, id, options, :post
  end

  # Public: Send a PUT request.
  #
  # See #call for arguments.
  def put resource, id='', options=nil
    call resource, id, options, :put
  end

  # Public: Send a DELETE request.
  #
  # See #call for arguments.
  def delete resource, id='', options=nil
    call resource, id, options, :delete
  end

  # Private: Creates a new Faraday connection object.
  def connection
    @connection ||= Faraday.new(API_URL % [@ssl ? 's' : '', @billomat_id]) do |conn|
      conn.request :json

      conn.response :mashify
      conn.response :json, :content_type => /\bjson$/
      conn.response :logger
      conn.response :raise_error
      conn.adapter  :net_http
      conn.options[:timeout] = 2
    end
  end
end
