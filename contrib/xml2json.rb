#!/usr/bin/env ruby
# encoding: utf-8
#
# Convert a given XML input to JSON like used with Billomat.

require 'active_support/core_ext'
require 'yajl/json_gem'

xml = ARGF.read
hash = Hash.from_xml(xml)

hash.keys.each do |key|
  if key.end_with?('s') && hash[key].kind_of?(Array)
    data = hash[key]
    hash[key] = { key[0..-2] => data }
  end
end

puts JSON.dump(hash)
