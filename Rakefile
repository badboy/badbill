require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)


require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
end

task :default => :spec
task :doc => :yard
