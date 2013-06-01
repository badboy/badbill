# encoding: utf-8

require 'spec_helper'

describe BadBill::Invoice do
  before :all do
    @badbill = new_badbill 1
  end

  it "fetches all invoices" do
    VCR.use_cassette("all invoices") do
      resp = BadBill::Invoice.all

      resp.size.should eq(2)
    end
  end

  it "fetches info about an invoice" do
    VCR.use_cassette("invoice info") do
      resp = BadBill::Invoice.find 352709

      resp.id.should eq(352709)
      resp.invoice_number.to_i.should eq(1)
    end
  end

  it "fetches aggregated invoices" do
    VCR.use_cassette("aggregated invoices") do
      resp = BadBill::Invoice.group_by :client

      resp.first.total_gross.should == "124.00"
    end
  end

  context "existing invoice 1" do
    before :each do
      VCR.use_cassette('draft item') do
        @invoice = BadBill::Invoice.find 352320
      end
    end

    it "marks invoice as complete" do
      VCR.use_cassette('invoice marked as complete') do
        @invoice.complete.should == true
      end
    end


    it "cancels an invoice" do
      VCR.use_cassette('invoice canceled') do
        @invoice.cancel.should == true
      end
    end

    it "deletes an invoice" do
      VCR.use_cassette('invoice deleted') do
        @invoice.delete.should == true
      end
    end
  end

  context "existing invoice 2" do
    before :each do
      VCR.use_cassette('invoice info') do
        @invoice = BadBill::Invoice.find 352709
      end
    end
    it "fetches the pdf" do
      VCR.use_cassette('fetched invoice pdf') do
        pdf = @invoice.pdf

        pdf.id.should == 356105
        pdf.invoice_id == 352709
      end
    end

    it "uploads a signature" do
      VCR.use_cassette('invoice uploaded signature') do
        file_content = StringIO.new "ruby"
        resp = @invoice.upload_signature file_content
        resp.should == true
      end
    end

    context "sending invoice as mail" do
      it "sends an invoice via mail" do
        VCR.use_cassette('invoice send mail') do
          resp = @invoice.email "M8R-10apg01@mailinator.com", "janerik@badbill.net",
            "subject", "body", {
              recipients: { cc: "f4a269895b2c7eccd43296d2b@mailinator.com" },
              filename: "invoice",
                attachments: {
                  attachment: {
                  filename: "more.pdf",
                  mimetype: "application/pdf",
                  base64file: "Zm9vYmFyCg=="
                }
              }
            }

          resp.should == true
        end
      end

      it "sends an invoice with only basic information" do
        VCR.use_cassette('invoice send email with basic info') do
          resp = @invoice.email "M8R-10apg01@mailinator.com", {recipients: { cc: "mail@test.example" }}
          resp.should == true
        end
      end

      it "sends an invoice with basic information and from" do
        VCR.use_cassette('invoice send email with basic info and from') do
          resp = @invoice.email "M8R-10apg01@mailinator.com", "sender@test.example", {recipients: { cc: "mail@test.example" }}
          resp.should == true
        end
      end

      it "sends an invoice with basic information, from and subject" do
        VCR.use_cassette('invoice send email with basic info from and subject') do
          resp = @invoice.email "M8R-10apg01@mailinator.com", "sender@test.example", "subject",
            {recipients: { cc: "mail@test.example" }}

          resp.should == true
        end
      end
    end
  end
end
