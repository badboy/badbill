# encoding: utf-8

require_relative '../helper'

describe BadBill::InvoicePayment do
  before :all do
    @badbill = BadBill.new "ruby", "12345"
  end

  it "fetches all invoice-payments" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoice-payments/").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoice-payments":{"invoice-payment":[{"id":1}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::InvoicePayment.all
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end
end
