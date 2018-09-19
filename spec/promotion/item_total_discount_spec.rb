require_relative "../spec_helper"

describe Promotion::ItemTotalDiscount do
  context "when order total is greater than the discount total" do
    it "calculates discount based on item total" do
      promotion = Promotion::ItemTotalDiscount.new(total: 30, percent: 10)
      checkout = Checkout.new(promotion)
      checkout.scan(Product.new(name: "foo", price: 20, code: "001"))
      checkout.scan(Product.new(name: "foo", price: 20, code: "002"))
      expect(checkout.total).to eq(36)
    end
  end

  context "when order total is equal to the discount total" do
    it "just returns items total without discount" do
      promotion = Promotion::ItemTotalDiscount.new(total: 30, percent: 10)
      checkout = Checkout.new(promotion)
      checkout.scan(Product.new(name: "foo", price: 20, code: "001"))
      checkout.scan(Product.new(name: "foo", price: 10, code: "002"))
      expect(checkout.total).to eq(30)
    end
  end

  context "when order total is less than the discount total" do
    it "just returns items total without discount" do
      promotion = Promotion::ItemTotalDiscount.new(total: 30, percent: 10)
      checkout = Checkout.new(promotion)
      checkout.scan(Product.new(name: "foo", price: 20, code: "001"))
      checkout.scan(Product.new(name: "foo", price: 5, code: "002"))
      expect(checkout.total).to eq(25)
    end
  end
end
