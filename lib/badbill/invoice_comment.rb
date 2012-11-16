# encoding: utf-8

class BadBill
  # The InvoiceComment resource handles all invoice comments.
  #
  # See http://www.billomat.com/en/api/invoices/comments-and-history/
  class InvoiceComment < BaseResource
    # Get all Invoice Comments for given invoice id.
    #
    # @param [Integer] invoice_id The invoice id to search for.
    #
    # @return [Array<InvoiceComment>] All found invoice comments.
    def self.all invoice_id, params={}
      params = params.merge(invoice_id: invoice_id)

      super params
    end
  end
end
