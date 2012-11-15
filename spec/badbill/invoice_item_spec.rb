# encoding: utf-8

require 'spec_helper'

describe BadBill::InvoiceItem do
  before :all do
    @badbill = new_badbill
  end

  it "fetches all invoice-item" do
    VCR.use_cassette("fetches invoice-item by id") do
      resp = BadBill::InvoiceItem.all 1

      resp.size.should eq(0)
    end
  end
end
