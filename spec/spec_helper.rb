# encoding: utf-8

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.formatter = Class.new do
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result) unless ENV['CI']
      File.open('coverage/covered_percent', 'w') do |f|
        f.puts result.source_files.covered_percent.to_i
      end
    end
  end

  SimpleCov.start
end

require 'rspec'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

here = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH.unshift here+'/lib'

def new_badbill
  fail('need BILLOMAT_KEY')     if ENV['BILLOMAT_KEY'].nil?
  fail('need BILLOMAT_API_KEY') if ENV['BILLOMAT_API_KEY'].nil?

  BadBill.new ENV['BILLOMAT_KEY'], ENV['BILLOMAT_API_KEY']
end

require 'badbill'
