# encoding: utf-8

class BadBill
  # Support access to resources via the connection object
  module MultipleAccounts
    # See {Client}
    def client
      wrapped Client
    end
    alias clients client

    # See {Invoice}
    def invoice
      wrapped Invoice
    end
    alias invoices invoice

    # See {InvoicePayment}
    def invoice_payment
      wrapped InvoicePayment
    end
    alias invoice_payments invoice_payment

    # See {InvoiceItem}
    def invoice_item
      wrapped InvoiceItem
    end
    alias invoice_items invoice_item

    # See {InvoiceComment}
    def invoice_comment
      wrapped InvoiceComment
    end
    alias invoice_comments invoice_comment

    # See {Recurring}
    def recurring
      wrapped Recurring
    end
    alias recurrings recurring

    private
    def wrapped obj
      Wrapper.new(obj, self)
    end

    # Wrap an object and proxy all methods.
    #
    # An instance of the object is created as needed (lazy)
    class Wrapper
      # @param [Object] obj The object to proxy to
      # @param [BadBill] conn The connection to use
      def initialize obj, conn
        @__obj__  = obj
        @__conn__ = conn
      end

      # Proxy all methods to the underlying object.
      def method_missing meth, *args
        if __wrapped__.respond_to?(meth)
          __wrapped__.send meth, *args
        else
          super
        end
      end

      def respond_to? meth
        __wrapped__.respond_to?(meth) || super
      end

      # Inspect this wrapper
      def inspect
        "#<#{self.class.name}(#{@__obj__.name}):#{__id__.to_s(16).rjust(14, '0')}>"
      end

      private
      # Create and return a new instance of the wrapped object.
      def __wrapped__
        return @__wrapped__ if @__wrapped__

        @__wrapped__ = @__obj__.new(@__conn__)
      end
    end
  end
end
