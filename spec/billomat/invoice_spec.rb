# encoding: utf-8

require_relative '../helper'

describe Billomat::Invoice do
  before :all do
    @billomat = Billomat.new "ruby", "12345"
  end

  it "fetches all invoices" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoices/").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoices":{"invoice":[{"id":1}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = Billomat::Invoice.all
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end

  it "fetches info about an invoice" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoices/1").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoice":{"id":1}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = Billomat::Invoice.find 1
    stub.should have_been_requested

    resp.id.should == 1
  end

  context "existing invoice" do
    before :each do
      stub_request(:get, "ruby.billomat.net/api/invoices/1").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:body => '{"invoice":{"id":1}}',
                  :headers => {'Content-Type' => 'application/json'})

      @invoice = Billomat::Invoice.find 1
    end

    it "marks invoice as complete" do
      stub = stub_request(:put, "ruby.billomat.net/api/invoices/1/complete").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:status => 200)

      @invoice.complete.should == true
      stub.should have_been_requested
    end

    it "cancels an invoice" do
      stub = stub_request(:put, "ruby.billomat.net/api/invoices/1/cancel").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:status => 200)

      @invoice.cancel.should == true
      stub.should have_been_requested
    end

    it "fetches the pdf" do
      body = <<-EOF
      {"pdf": {
       "id": 1,
        "created": "2009-09-02T12:04:15+02:00",
        "invoice_id": 1,
        "filename": "invoice_1.pdf",
        "mimetype": "application/pdf",
        "filesize": "1",
        "base64file": "foobar"
      }}
      EOF

      stub = stub_request(:get, "ruby.billomat.net/api/invoices/1/pdf").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:body => body, :headers => {
          'Content-Type' => 'application/json'
        })

      pdf = @invoice.pdf

      stub.should have_been_requested
      pdf.id.should == 1
      pdf.invoice_id == 1
    end

    it "sends an invoice via mail" do
      body = {
        "email" => {
          "from" => "sender@test.example",
          "recipients" => {
            "to" => "recv@test.example",
            "cc" => "mail@test.example"
          },
          "subject" => "subject",
          "body" => "body",
          "filename" => "invoice",
          "attachments" => {
            "attachment" => {
              "filename" => "more.pdf",
              "mimetype" => "application/pdf",
              "base64file" => "foobar"
            }
          }
        }
      }

      stub = stub_request(:post, "ruby.billomat.net/api/invoices/1/email").
        with(:headers => {'Accept' => 'application/json'}, :body => body).
        to_return(:headers => {
          'Content-Type' => 'application/json'
        })

      resp = @invoice.email "recv@test.example", "sender@test.example",
        "subject", "body", {
        recipients: { cc: "mail@test.example" },
        filename: "invoice",
        attachments: {
          attachment: {
            filename: "more.pdf",
            mimetype: "application/pdf",
            base64file: "foobar"
          }
        }
      }

      stub.should have_been_requested
      resp.should == true
    end
  end
end
