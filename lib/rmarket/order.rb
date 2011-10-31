module RMarket
  class Order
    attr_reader :type, :price, :trader
    
    def initialize(type, price, trader=nil)
      @type, @price, @trader = type, price, trader
    end
  end
end