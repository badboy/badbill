#!/usr/bin/env ruby
# encoding: utf-8
#
# Start a pry shell with already loaded BadBill client.

require 'ap'
require 'pry'
require_relative '../lib/badbill'

c = BadBill.new ENV['BILLOMAT_KEY'], ENV['BILLOMAT_API_KEY']

binding.pry
