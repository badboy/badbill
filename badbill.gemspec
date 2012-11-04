Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.name    = 'badbill'
  s.version = '0.0.3dev'

  s.summary     = "Simple but working API client for the Billomat API."
  s.description = <<-EOF
Fast and easy access to all resources the Billomat API provides (not all resources are Ruby classes, yet).
  EOF

  s.authors  = ["Jan-Erik Rediger"]
  s.email    = 'badboy@archlinux.us'
  s.homepage = 'https://github.com/badboy/badbill'

  s.add_dependency 'yajl-ruby'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'hashie'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'

  # = MANIFEST =
  s.files = %w[
    ./CONTRIBUTING.md
    ./Gemfile
    ./Gemfile.lock
    ./Guardfile
    ./LICENSE
    ./README.md
    ./Rakefile
    ./badbill.gemspec
    ./lib/badbill.rb
    ./lib/badbill/base_resource.rb
    ./lib/badbill/client.rb
    ./lib/badbill/forward_methods.rb
    ./lib/badbill/invoice.rb
    ./lib/badbill/invoice_item.rb
    ./lib/badbill/invoice_payment.rb
    ./lib/badbill/recurring.rb
    ./lib/badbill/resource.rb
    ./spec/badbill/base_resource_spec.rb
    ./spec/badbill/client_spec.rb
    ./spec/badbill/invoice_item_spec.rb
    ./spec/badbill/invoice_payment_spec.rb
    ./spec/badbill/invoice_spec.rb
    ./spec/badbill/recurring_spec.rb
    ./spec/badbill_spec.rb
    ./spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end
