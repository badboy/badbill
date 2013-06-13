# encoding: utf-8

class BadBill
  # The InvoicePayment resource handles all invoice payments.
  #
  # See http://www.billomat.com/en/api/invoices/payments/
  class InvoicePayment < BaseResource
    # Create a new invoice payment.
    #
    # @param [String,] invoice_id The ID of the invoice
    # @param [String,Numeric] amount The paid amount
    # @param [Boolean] is_paid Wether the invoice should be marked as paid
    #                  or not
    # @return [InvoicePayment,Hashie::Mash] New payment with id and data set
    #                                       or hash if any error happened
    def create invoice_id, amount, is_paid=false, params={}
      params['invoice_id']           = invoice_id
      params['amount']               = amount
      params['mark_invoice_as_paid'] = is_paid

      res = post(resource_name, {resource_name_singular => params})
      return res if res.error

      res_data = res.__send__(resource_name_singular)
      new_with_data res_data.id.to_i, res_data
    end
  end
end
