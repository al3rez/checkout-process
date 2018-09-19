class Checkout
  attr_reader :order

  def initialize(*promotions)
    @promotions = promotions || []
    @order = Order.new
    @total = 0
  end

  def scan(item)
    @order << item
    @total = @order.total
  end

  def total
    recalculate!
    @total.to_f.round(2)
  end

  def recalculate!
    return @total if @promotions.empty?

    @promotions.each do |promotion|
      @total = promotion.perform(@order)
    end
  end
end
