module Promotion
  class ItemTotalDiscount < Base
    def initialize(total:, percent:)
      @total = total
      @percent = percent
    end

    def eligible?(order, options = {})
      order.total > @total
    end

    def perform(order)
      return order.total unless eligible?(order)
      calculate_discount(order)
    end

    private

    def calculate_discount(order)
      order.total - ((@percent.to_f / 100) * order.total)
    end
  end
end
