# encoding: utf-8

require 'spec_helper'

describe BadBill::InvoicePayment do
  before :all do
    @badbill = new_badbill
  end

  it "fetches all invoice-payments" do
    VCR.use_cassette('invoice payments') do
      resp = BadBill::InvoicePayment.all

      resp.size.should eq(0)
    end
  end
end
