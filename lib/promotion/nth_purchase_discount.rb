module Promotion
  class NthPurchaseDiscount < Base
    def initialize(**kwargs)
      @product = kwargs.fetch(:product)
      @purchases = kwargs.fetch(:purchases)
      @percent = kwargs.fetch(:percent, 0)
      @price = kwargs.fetch(:price, 0)

      if @product.nil? || @product == 0
        raise ArgumentError, "Product cannot be nil or zero" 
      end

      if @price.zero? && @percent.zero?
        raise ArgumentError, "Both price and percent cannot be zero" 
      end
    end

    def eligible?(order, options = {})
      return false if @purchases.zero?
      @_purchases = order.items.select { |p| p.code == @product.code }
      true unless @_purchases.nil? || @_purchases.count < @purchases
    end

    def perform(order)
      return order.total unless eligible?(order)

      update_price unless @price.zero?
      add_discount unless @percent.zero?
      recalculate_total(order)
    end

    private

    def add_discount
      @_purchases.each do |p|
        p.price = p.price - ((@percent.to_f / 100) * p.price)
      end
    end

    def update_price
      @_purchases.each do |p|
        p.price = @price
      end
    end

    def recalculate_total(order)
      (order.items - @_purchases).map(&:price).sum + @_purchases.map(&:price).sum
    end
  end
end
