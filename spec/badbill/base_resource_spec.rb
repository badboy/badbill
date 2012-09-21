# encoding: utf-8

require_relative '../helper'

describe BadBill::BaseResource do
  it "can't set a new ID" do
    b = BadBill::BaseResource.new 42, {}
    b.id.should == 42
    lambda{ b.id = 23 }.should raise_error(NoMethodError)
    b.id.should == 42
  end
end
