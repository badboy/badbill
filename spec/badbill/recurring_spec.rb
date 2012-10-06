# encoding: utf-8

require_relative '../helper'

describe BadBill::Recurring do
  before :all do
    @badbill = BadBill.new "ruby", "12345"
  end

  it "fetches all recurring invoices" do
    stub = stub_request(:get, "ruby.billomat.net/api/recurrings/").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"recurrings":{"recurring":[{"id":1}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::Recurring.all
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end
end
