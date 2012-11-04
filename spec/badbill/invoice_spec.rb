# encoding: utf-8

require 'spec_helper'

describe BadBill::Invoice do
  before :all do
    @badbill = BadBill.new "ruby", "12345"
  end

  it "fetches all invoices" do
    body = {
      'invoices' => {
        'invoice' => {
          id: 1
        },
        '@total' => 1
      }
    }
    stub = stub_request(:get, "ruby.billomat.net/api/invoices/").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => body,
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::Invoice.all
    stub.should have_been_requested

    resp.size.should == 1
    resp.first.id.should == 1
  end

  it "fetches info about an invoice" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoices/1").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoice":{"id":1}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::Invoice.find 1
    stub.should have_been_requested

    resp.id.should == 1
  end

  it "fetches aggregated invoices" do
    stub = stub_request(:get, "ruby.billomat.net/api/invoices/?group_by=client").
      with(:headers => {'Accept' => 'application/json'}).
      to_return(:body => '{"invoice-groups":{"invoice-group":[{"total_gross":"42.23"}]}}',
               :headers => {'Content-Type' => 'application/json'})

    resp = BadBill::Invoice.group_by :client
    stub.should have_been_requested

    resp.first.total_gross.should == "42.23"
  end

  context "existing invoice" do
    before :each do
      stub_request(:get, "ruby.billomat.net/api/invoices/1").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:body => '{"invoice":{"id":1,"status":"DRAFT"}}',
                  :headers => {'Content-Type' => 'application/json'})

      @invoice = BadBill::Invoice.find 1
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

    it "deletes an invoice" do
      stub = stub_request(:delete, "ruby.billomat.net/api/invoices/1").
        with(:headers => {'Accept' => 'application/json'}).
        to_return(:status => 200)

      @invoice.delete.should == true
      stub.should have_been_requested
    end

    it "fetches the pdf" do
      body = {
        "pdf" => {
         "id" => 1,
          "created" => "2009-09-02T12 =>04 =>15+02 =>00",
          "invoice_id" => 1,
          "filename" => "invoice_1.pdf",
          "mimetype" => "application/pdf",
          "filesize" => "1",
          "base64file" => "foobar"
        }
      }

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

    it "uploads a signature" do
      body = {"signature" => {"base64file" => "cnVieQ==\n"}}
      stub = stub_request(:put, "ruby.billomat.net/api/invoices/1/upload-signature").
        with(:headers => {'Accept' => 'application/json'}, :body => body).
        to_return(:status => 200)

      @invoice.status = "OPEN"
      file_content = StringIO.new "ruby"
      resp = @invoice.upload_signature file_content
      resp.should == true

      stub.should have_been_requested
    end

    context "sending invoice as mail" do
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

      it "sends an invoice with only basic information" do
        body = {
          "email" => {
            "recipients" => {
              "to" => "recv@test.example",
              "cc" => "mail@test.example",
            }
          }
        }

        stub = stub_request(:post, "ruby.billomat.net/api/invoices/1/email").
          with(:headers => {'Accept' => 'application/json'}, :body => body).
          to_return(:headers => {
          'Content-Type' => 'application/json'
        })

        resp = @invoice.email "recv@test.example", {recipients: { cc: "mail@test.example" }}

        stub.should have_been_requested
        resp.should == true
      end

      it "sends an invoice with basic information and from" do
        body = {
          "email" => {
            "recipients" => {
              "to" => "recv@test.example",
              "cc" => "mail@test.example",
            },
            "from" => "sender@test.example"
          }
        }

        stub = stub_request(:post, "ruby.billomat.net/api/invoices/1/email").
          with(:headers => {'Accept' => 'application/json'}, :body => body).
          to_return(:headers => {
          'Content-Type' => 'application/json'
        })

        resp = @invoice.email "recv@test.example", "sender@test.example", {recipients: { cc: "mail@test.example" }}

        stub.should have_been_requested
        resp.should == true
      end

      it "sends an invoice with basic information, from and subject" do
        body = {
          "email" => {
            "recipients" => {
              "to" => "recv@test.example",
              "cc" => "mail@test.example",
            },
            "from" => "sender@test.example",
            "subject" => "subject"
          }
        }

        stub = stub_request(:post, "ruby.billomat.net/api/invoices/1/email").
          with(:headers => {'Accept' => 'application/json'}, :body => body).
          to_return(:headers => {
          'Content-Type' => 'application/json'
        })

        resp = @invoice.email "recv@test.example", "sender@test.example", "subject",
          {recipients: { cc: "mail@test.example" }}

        stub.should have_been_requested
        resp.should == true
      end
    end
  end
end
