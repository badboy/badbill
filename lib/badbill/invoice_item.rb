# encoding: utf-8

class BadBill
  # The InvoiceItem resource handles all invoice items.
  #
  # See http://www.billomat.com/en/api/invoices/items/
  class InvoiceItem < BaseResource
    # Get all resources of this type.
    #
    # @param [Integer] invoice_id The invoice id to search for.
    #
    # @return [Array<InvoiceItem>] All found invoice items.
    def self.all invoice_id
      super invoice_id: invoice_id
    end
  end
end
