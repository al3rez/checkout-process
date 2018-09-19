require_relative "../spec_helper"

describe Promotion::NthPurchaseDiscount do
  context "with unmatch purchases" do
    it "just returns items total without discount" do
      product = Product.new(name: "foo", price: 20, code: "001")
      promotion = Promotion::NthPurchaseDiscount.new(
        purchases: 0,
        product: product,
        price: 3.99,
      )

      checkout = Checkout.new(promotion)
      checkout.scan(product)
      checkout.scan(product)
      checkout.scan(Product.new(name: "bar", price: 10, code: "002"))

      expect(checkout.total).to eq(50)
    end
  end

  context "with price" do
    it "updates purchases price" do
      product = Product.new(name: "foo", price: 20, code: "001")
      promotion = Promotion::NthPurchaseDiscount.new(
        purchases: 2,
        product: product,
        price: 3.99,
      )

      checkout = Checkout.new(promotion)
      checkout.scan(product)
      checkout.scan(product)
      checkout.scan(Product.new(name: "bar", price: 10, code: "002"))

      expect(checkout.total).to eq(17.98)
    end
  end

  context "with perecent" do
    it "adds discount to purchases" do
      product = Product.new(name: "foo", price: 20, code: "001")
      promotion = Promotion::NthPurchaseDiscount.new(
        purchases: 2,
        product: product,
        percent: 10,
      )

      checkout = Checkout.new(promotion)
      checkout.scan(product)
      checkout.scan(product.clone)
      checkout.scan(Product.new(name: "bar", price: 10, code: "002"))

      expect(checkout.total).to eq(46)
    end
  end

  context "with zero price and percent" do
    it "raises an ArgumentError" do
      promotion = -> () {
        Promotion::NthPurchaseDiscount.new(
          purchases: 2,
          product: nil,
          price: 0,
          percent: 0,
        )
      }

      expect { promotion.() }.to raise_error(ArgumentError)
    end
  end

  context "with zero or nil product" do
    it "raises an ArgumentError" do
      promotion = -> () {
        Promotion::NthPurchaseDiscount.new(
          purchases: 2,
          product: nil,
          price: 10,
        )
      }

      expect { promotion.() }.to raise_error(ArgumentError)
    end
  end
end
