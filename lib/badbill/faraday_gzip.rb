# encoding: utf-8

require 'zlib'
require 'faraday_middleware/response_middleware'

# Extend Faraday with some middleware
module FaradayMiddleware
  # Force Gzip decoding if needed.
  class Gzip < ResponseMiddleware
    define_parser do |body|
      Zlib::GzipReader.new(StringIO.new(body)).read
    end

    def parse_response?(env)
      super && env[:response_headers]['content-encoding'] == "gzip"
    end
  end
end

Faraday::Response.register_middleware :gzip => FaradayMiddleware::Gzip
