# encoding: utf-8

require 'spec_helper'

describe BadBill::InvoiceItem do
  before :all do
    @badbill = BadBill.new "ruby", "12345"
  end

  it "fetches all invoice-item" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoice-items/?invoice_id=1").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoice-items":{"invoice-item":[{"id":1}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::InvoiceItem.all(1)
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end
end
