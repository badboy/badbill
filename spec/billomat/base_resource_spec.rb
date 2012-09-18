# encoding: utf-8

require_relative '../helper'

describe Billomat::BaseResource do
  it "can't set a new ID" do
    b = Billomat::BaseResource.new 42, {}
    b.id.should == 42
    lambda{ b.id = 23 }.should raise_error(NoMethodError)
    b.id.should == 42
  end
end
