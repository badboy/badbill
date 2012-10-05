# encoding: utf-8

class BadBill
  # The InvoiceItem resource handles all invoice items.
  #
  # See http://www.billomat.com/en/api/invoices/items/
  class InvoiceItem < BaseResource
    # Get all resources of this type.
    #
    # @param [Hash] filter An Hash of filter parameters,
    #                      see the online documentation for allowed values.
    #
    # @return [Array<Resource>] All found resources.
    def self.all invoice_id
      all = get resource_name, invoice_id: invoice_id
      return all if all.error

      items = all['invoice-items']['invoice-item'] || []
      items.map do |res|
        new res.id, res
      end
    end
  end
end
