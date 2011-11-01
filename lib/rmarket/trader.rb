module RMarket
  class Trader
    attr_reader :cash, :shares, :value_function, :beliefs, :id
    attr_accessor :trading_strategy
    
    def initialize(cash=0, shares={}, value_function=nil, trading_strategy=nil, beliefs=nil, id=nil)
      @cash, @shares, @trading_strategy, @value_function, @beliefs, @id = cash, shares, trading_strategy, value_function, beliefs, id
    end
    
    def update_account(cash, shares, asset_label)
      @shares[asset_label] = @shares[asset_label].to_f + shares
      @cash += cash
    end
    
    def update_beliefs(news); @beliefs.update(news); end
    
    def submit_orders(order_book)
      @trading_strategy.construct_orders(@cash, @shares, @value_function, @beliefs, order_book.snapshot).each {|order| order_book.submit_order(order)}
    end
  end
end