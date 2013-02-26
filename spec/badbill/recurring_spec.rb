# encoding: utf-8

require 'spec_helper'

describe BadBill::Recurring do
  before :all do
    @badbill = new_badbill 1
  end

  it "fetches all recurring invoices" do
    VCR.use_cassette("all recurring invoices") do
      resp = BadBill::Recurring.all

      resp.size.should eq(1)
      resp.first.id.should eq(21885)
    end
  end
end
