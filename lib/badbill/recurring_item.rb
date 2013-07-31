# encoding: utf-8

class BadBill
  # The RecurringItem resource handles all recurring items.
  #
  # See http://www.billomat.com/en/api/recurrings/items
  class RecurringItem < BaseResource
    # Get all resources of this type.
    #
    # @param [Integer] recurring_id The recurring id to search for.
    #
    # @return [Array<RecurringItem>] All found recurring items.
    def all recurring_id
      super recurring_id: recurring_id
    end
  end
end
