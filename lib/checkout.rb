class Checkout
  def initialize(*promotions)
    @promotions = promotions
    @order = Order.new
    @total = 0
  end

  def scan(item)
    @order << item
  end

  def total
    recalculate!
    @total.to_f.round(2)
  end

  def recalculate!
    @promotions.each do |promotion|
      @total = promotion.perform(@order)
    end
  end
end
