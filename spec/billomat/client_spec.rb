# encoding: utf-8

require_relative '../helper'

describe Billomat::Client do
  before :all do
    @billomat = Billomat.new "ruby", "12345"
  end

  it "fetches all clients" do
    stub = stub_request(:get, "ruby.billomat.net/api/clients/").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"clients":{"client":[{"id":1}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = Billomat::Client.all
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end

  it "fetches info about myself" do
    stub = stub_request(:get, "ruby.billomat.net/api/clients/myself").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"client":{"id":1}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = Billomat::Client.myself
    stub.should have_been_requested

    resp.id.should == 1
    resp.myself?.should == true
  end

  it "fetches info about another client" do
    stub = stub_request(:get, "ruby.billomat.net/api/clients/1").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"client":{"id":1}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = Billomat::Client.find 1
    stub.should have_been_requested

    resp.id.should == 1
    resp.myself?.should == false
  end
end
