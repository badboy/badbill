# encoding: utf-8

require 'spec_helper'

describe BadBill::InvoiceComment do
  before :all do
    @badbill = new_badbill
  end

  it "fetches all invoice-comments" do
    VCR.use_cassette("invoice-comments by invoice id") do
      resp = BadBill::InvoiceComment.all 360264

      resp.size.should eq(3)
    end
  end

  it "fetches all invoice-comments for PAYED status" do
    VCR.use_cassette("invoice-comments by invoice id and actionkey PAYMENT") do
      resp = BadBill::InvoiceComment.all 360264, actionkey: 'PAYMENT'

      resp.size.should eq(1)
    end
  end
end
