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

here = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH.unshift here+'/lib'

def new_badbill version
  key = nil
  id  = nil

  # We need a working id/key combination just once,
  # test cases are recorded through VCR for later use.
  #
  # Whenever a new test is added, get a new API key.
  case version
  when 1
    id  = 'rediger'
    key = 'e1923a9ab25fc955be3321725be882bd'
  end
  fail('need Billomat ID')      unless id
  fail('need Billomat API key') unless key

  BadBill.new id, key
end

require 'badbill'
