# encoding: utf-8

require 'base64'

class Billomat
  # Public: The resource handles all invoices.
  #
  # See http://www.billomat.com/en/api/invoices
  class Invoice < BaseResource
    # Public: Get the PDF invoice.
    #
    # Returns a Hash-like object containing the ID, filesize, base64file and other parameters.
    # See http://www.billomat.com/en/api/invoices for all parameters.
    def pdf
      resp = get resource_name, "#{id}/pdf"
      resp.pdf
    end

    # Public: Closes a statement in the draft status (DRAFT). Here, the
    # status of open (OPEN) or overdue (OVERDUE) is set and a PDF is
    # generated and stored in the file system.
    #
    # template_id - String or Integer ID of the Template used to create pdf,
    #               if not set, default template is used (default: nil).
    def complete template_id=nil
      data = { complete: {} }
      data[:complete] = { template_id: template_id } if template_id
      put resource_name, "#{id}/complete", data
    end

    # Public: Cancel an invoice.
    def cancel
      put resource_name, "#{id}/cancel"
    end

    # Public: Sends an invoice by email.
    #
    # to      - String recipient of the email.
    #           cc and bcc can be set in the `more` Hash.
    # from    - String sender email address (default: nil).
    # subject - String subject for the email (default: nil).
    # body    - String body for the email (default: nil).
    # more    - Hash-like object including more options.
    #           See online documentation for all allowed parameters.
    #
    # from, subject or body can be replaced by more.
    def email to, from=nil, subject=nil, body=nil, more={}
      data = { recipients: {} }

      if !more && from.kind_of?(Hash)
        more = from
        from = nil
      end

      if !more && subject.kind_of?(Hash)
        more = subject
        subject = nil
      end

      if !more && body.kind_of?(Hash)
        more = body
        body = nil
      end

      data[:from]    = from    if from
      data[:subject] = subject if subject
      data[:body]    = body    if body

      data.merge more
      data[:recipients][:to] = to
      post resource_name, "#{id}/email", data
    end

    # Public: Uploads a digital signature for a given invoice.
    #
    # The status of the invoice may not be DRAFT.
    #
    # file - A String file name or a object responding to #read
    #        This will be base64-encoded before send.
    #
    # Returns false if status is DRAFT or true if everything was successfull.
    def upload_signature file
      return false if data.status == 'DRAFT'

      file = File.open(file, 'r') unless file.respond_to?(:read)

      base64 = Base64.encode64 file.read
      put resource_name, "#{id}/upload-signature", { signature: { base64file: base64 } }
      true
    end
  end
end
