class Product
  attr_accessor :code, :name, :price

  def initialize(**kwargs)
    @code = kwargs.fetch(:code, "")
    @name = kwargs.fetch(:name, "")
    @price = kwargs.fetch(:price, 0)
  end
end
