module RMarket
  class Order
    attr_reader :type, :asset_label, :price, :trader
    attr_accessor :quantity
    
    def initialize(type, price, trader=nil, quantity=1, asset_label="")
      @type, @price, @trader, @quantity, @asset_label = type, price, trader, quantity, asset_label
    end
  end
end