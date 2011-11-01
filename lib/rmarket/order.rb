module RMarket
  class Order
    attr_reader :type, :price, :trader
    attr_accessor :quantity
    
    def initialize(type, price, trader=nil, quantity=1)
      @type, @price, @trader, @quantity = type, price, trader, quantity
    end
  end
end