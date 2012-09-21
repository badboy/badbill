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

here = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH.unshift here+'/lib'

require 'badbill'
