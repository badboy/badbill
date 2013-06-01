# encoding: utf-8

class BadBill
  # The InvoiceComment resource handles all invoice comments.
  #
  # See http://www.billomat.com/en/api/invoices/comments-and-history/
  class InvoiceComment < BaseResource
    # Get all Invoice Comments for given invoice id.
    #
    # @param [Integer] invoice_id The invoice id to search for.
    # @param [String,Array] actionkey Indicates what kind of comment it is. See API docu for possible values. An Array will be joined into a String.
    #
    # @return [Array<InvoiceComment>] All found invoice comments.
    def self.all invoice_id, actionkey=nil
      params = { invoice_id: invoice_id }
      if actionkey
        actionkey = actionkey.join(',') if actionkey.respond_to?(:join)
        params[:actionkey] = actionkey
      end

      super params
    end
  end
end
