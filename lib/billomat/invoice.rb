# encoding: utf-8

require 'base64'

class Billomat
  # The resource handles all invoices.
  #
  # See http://www.billomat.com/en/api/invoices
  class Invoice < BaseResource
    # Get the PDF invoice.
    #
    #
    # @return [Hashie::Mash] Hash containing the ID, filesize, base64file and
    #                        other parameters.
    #                        See http://www.billomat.com/en/api/invoices for
    #                        all parameters.
    def pdf
      resp = get resource_name, "#{id}/pdf"
      resp.pdf
    end

    # Closes a statement in the draft status (DRAFT). Here, the
    # status of open (OPEN) or overdue (OVERDUE) is set and a PDF is
    # generated and stored in the file system.
    #
    # @param [String,Integer] template_id ID of the Template used to create pdf,
    #                                     If not set, default template is used.
    #
    # @return [Boolean] Wether or not the call was successfull.
    def complete template_id=nil
      data = { complete: {} }
      data[:complete] = { template_id: template_id } if template_id
      resp = put resource_name, "#{id}/complete", data

      !resp
    end

    # Cancel an invoice.
    #
    # @return [Boolean] Wether or not the call was successfull.
    def cancel
      resp = put resource_name, "#{id}/cancel"
      !resp
    end

    # Sends an invoice by email.
    #
    # @param [String] to      Recipient of the email.
    #                         cc and bcc can be set in the `more` Hash.
    # @param [String] from    Sender email address.
    # @param [String] subject Subject for the email.
    # @param [String] body    Body for the email.
    # @param [Hash] more      Hash-like object including more options.
    #                         See online documentation for all allowed parameters.
    #
    # from, subject or body can be replaced by more.
    #
    # @return [Boolean] Wether or not the call was successfull.
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

      data.merge! more
      data[:recipients][:to] = to

      resp = post resource_name, "#{id}/email", email: data
      !resp
    end

    # Uploads a digital signature for a given invoice.
    #
    # The status of the invoice may not be DRAFT.
    #
    # @param [String,#read] file file name or a object responding to #read.
    #                            This will be base64-encoded before send.
    #
    # @return [Boolean] false if status is DRAFT or another error occured. true if everything was successfull.
    def upload_signature file
      return false if data.status == 'DRAFT'

      file = File.open(file, 'r') unless file.respond_to?(:read)

      base64 = Base64.encode64 file.read
      put resource_name, "#{id}/upload-signature", { signature: { base64file: base64 } }
      true
    end
  end
end
