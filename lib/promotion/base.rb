module Promotion
  class Base
    def eligible?(order, options = {})
      true if order.is_a?(Order)
    end

    def perform(order)
      eligible?(order)
    end
  end
end
