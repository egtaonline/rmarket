module RMarket
  class Trader
    attr_reader :cash, :shares, :value_function, :beliefs
    attr_accessor :pricing_strategy
    
    def initialize(cash=0, shares={}, value_function=nil, pricing_strategy=nil, beliefs=nil)
      @cash, @shares, @pricing_strategy, @value_function, @beliefs = cash, shares, pricing_strategy, value_function, beliefs
    end
    
    def update_account(cash, shares, asset_label)
      @shares[asset_label] = @shares[asset_label].to_f + shares
      @cash += cash
    end
  end
end