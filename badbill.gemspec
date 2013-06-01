Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.name    = 'badbill'
  s.version = '0.1.0'

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
    ./lib/badbill/faraday_gzip.rb
    ./lib/badbill/forward_methods.rb
    ./lib/badbill/invoice.rb
    ./lib/badbill/invoice_comment.rb
    ./lib/badbill/invoice_item.rb
    ./lib/badbill/invoice_payment.rb
    ./lib/badbill/recurring.rb
    ./lib/badbill/resource.rb
    ./spec/badbill/base_resource_spec.rb
    ./spec/badbill/client_spec.rb
    ./spec/badbill/invoice_comment_spec.rb
    ./spec/badbill/invoice_item_spec.rb
    ./spec/badbill/invoice_payment_spec.rb
    ./spec/badbill/invoice_spec.rb
    ./spec/badbill/recurring_spec.rb
    ./spec/badbill_spec.rb
    ./spec/fixtures/vcr_cassettes/aggregated_invoices.yml
    ./spec/fixtures/vcr_cassettes/all_clients.yml
    ./spec/fixtures/vcr_cassettes/all_invoices.yml
    ./spec/fixtures/vcr_cassettes/all_recurring_invoices.yml
    ./spec/fixtures/vcr_cassettes/client_on_change.yml
    ./spec/fixtures/vcr_cassettes/draft_item.yml
    ./spec/fixtures/vcr_cassettes/existent_client.yml
    ./spec/fixtures/vcr_cassettes/fetched_invoice_pdf.yml
    ./spec/fixtures/vcr_cassettes/fetches_invoice-item_by_id.yml
    ./spec/fixtures/vcr_cassettes/invoice-comments_by_invoice_id.yml
    ./spec/fixtures/vcr_cassettes/invoice-comments_by_invoice_id_and_actionkey_PAYMENT.yml
    ./spec/fixtures/vcr_cassettes/invoice-comments_by_invoice_id_and_actionkeys.yml
    ./spec/fixtures/vcr_cassettes/invoice_canceled.yml
    ./spec/fixtures/vcr_cassettes/invoice_deleted.yml
    ./spec/fixtures/vcr_cassettes/invoice_info.yml
    ./spec/fixtures/vcr_cassettes/invoice_marked_as_complete.yml
    ./spec/fixtures/vcr_cassettes/invoice_payments.yml
    ./spec/fixtures/vcr_cassettes/invoice_send_email_with_basic_info.yml
    ./spec/fixtures/vcr_cassettes/invoice_send_email_with_basic_info_and_from.yml
    ./spec/fixtures/vcr_cassettes/invoice_send_email_with_basic_info_from_and_subject.yml
    ./spec/fixtures/vcr_cassettes/invoice_send_mail.yml
    ./spec/fixtures/vcr_cassettes/invoice_send_mail_invalid_address.yml
    ./spec/fixtures/vcr_cassettes/invoice_uploaded_signature.yml
    ./spec/fixtures/vcr_cassettes/myself_client.yml
    ./spec/fixtures/vcr_cassettes/new_client.yml
    ./spec/fixtures/vcr_cassettes/non_existent_client.yml
    ./spec/fixtures/vcr_cassettes/save_for_non-existent_client.yml
    ./spec/fixtures/vcr_cassettes/wrong_data_for_client.yml
    ./spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end
