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

  it "saves changes to client data" do
    body = { client: {name: "old name", "id" => 1} }
    stub_request(:get, "ruby.billomat.net/api/clients/1").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => body,
               :headers => {'Content-Type' => 'application/json'})

    client = Billomat::Client.find 1

    body = { client: {name: "new name", "id" => 1} }
    stub = stub_request(:put, "ruby.billomat.net/api/clients/1").
      with(:headers => {'Accept' => 'application/json'}, :body => body).
      to_return(:status => 200)

    client.name.should == "old name"
    client.name = "new name"
    client.save.should == true
    stub.should have_been_requested
  end

  it "creates a new client with given data" do
    body = {
      "client" => {
        "name"                 => "Musterfirma",
        "salutation"           => "Herr",
        "first_name"           => "Max",
        "last_name"            => "Muster",
        "street"               => "Musterstraße 123",
        "zip"                  => "12345",
        "city"                 => "Musterstadt",
        "state"                => "Bundesland",
        "country_code"         => "DE",
      }
    }

    body_return = { "client" => body["client"].dup }
    body_return["client"]["id"] = 42
    body_return["client"]["created"] = "2007-12-13T12:12:00+01:00"
    #require 'pry'; binding.pry

    stub = stub_request(:post, "ruby.billomat.net/api/clients/").
      with(:body => body.to_json, :headers => {'Accept' => 'application/json',
        'Content-Type'=>'application/json'}).
      to_return(:status => 201, :body => body_return,
                :headers => {'Content-Type' => 'application/json'})

    client = Billomat::Client.create body["client"]
    stub.should have_been_requested
    client.id.should == 42
  end
end
