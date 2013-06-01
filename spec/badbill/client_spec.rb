# encoding: utf-8

require 'spec_helper'

describe BadBill::Client do
  before :all do
    @badbill = new_badbill 1
  end

  it "fetches all clients" do
    VCR.use_cassette('all_clients') do
      resp = BadBill::Client.all

      resp.size.should eq(1)
      resp.first.id.should eq(169499)
    end
  end

  it "fetches info about myself" do
    VCR.use_cassette('myself_client') do
      resp = BadBill::Client.myself

      resp.id.should eq(148386)
      resp.myself?.should be_true
    end
  end

  it "fetches info about another client" do
    VCR.use_cassette('existent client') do
      resp = BadBill::Client.find 169499

      resp.id.should eq(169499)
      resp.myself?.should be_false
    end
  end

  it "returns nil when no client found" do
    VCR.use_cassette('non existent client') do
      resp = BadBill::Client.find 11111

      resp.should be_nil
    end
  end

  it "saves changes to client data" do
    client = nil
    VCR.use_cassette('existent client') do
      client = BadBill::Client.find 169499
    end

    VCR.use_cassette('client on change') do
      client.name.should eq("Jan-Erik Rediger")
      client.name = "new name"
      saved = client.save

      saved.error.should be_nil
      saved.name.should eq("new name")
      client.name.should eq("new name")
    end
  end

  it "returns error on failed save" do
    VCR.use_cassette('save for non-existent client') do
      client = BadBill::Client.new 169500, Hashie::Mash.new(name: "foo")
      client.name = "new name"
      saved = client.save

      saved.error.should be_a(Faraday::Error::ClientError)
    end
  end

  it "creates a new client with given data" do
    VCR.use_cassette('new client') do
      data = {
        "name"         => "Musterfirma",
        "salutation"   => "Herr",
        "first_name"   => "Max",
        "last_name"    => "Muster",
        "street"       => "Musterstraße 123",
        "zip"          => "12345",
        "city"         => "Musterstadt",
        "state"        => "Bundesland",
        "country_code" => "DE",
      }

      client = BadBill::Client.create data
      client.id.should_not be_nil
      client.name.should eq("Musterfirma")
    end
  end

  context "create with wrong data" do
    it "returns an error" do
      VCR.use_cassette('wrong data for client') do
        data = { "email" => "this@is.invalid" }
        client = BadBill::Client.create data

        client.error.should be_a(Faraday::Error::ClientError)
      end
    end
  end
end
