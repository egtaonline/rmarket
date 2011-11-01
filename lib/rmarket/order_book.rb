module RMarket
  class OrderBook
    def initialize
      @buy_ledger = OrderLedger.new("buy")
      @sell_ledger = OrderLedger.new("sell")
    end
    
    def matches?(order)
      if order.type == "buy"
        return false if @sell_ledger.outstanding_order_count == 0 || ask > order.price
      else
        return false if @buy_ledger.outstanding_order_count == 0 || bid < order.price
      end
      true
    end
    
    def submit_order(order)
      if order.type == "buy"
        order = @sell_ledger.transact(order) if matches?(order)
        @buy_ledger.submit_order(order) if order != nil
      else
        order = @buy_ledger.transact(order) if matches?(order)
        @sell_ledger.submit_order(order) if order != nil
      end
    end
    
    def outstanding_bid_count; @buy_ledger.outstanding_order_count; end
    def outstanding_ask_count; @sell_ledger.outstanding_order_count; end
    
    def bid; @buy_ledger.bid; end
    def ask; @sell_ledger.ask; end

    def remove_prior_orders(trader)
      @buy_ledger.remove_prior_orders(trader)
      @sell_ledger.remove_prior_orders(trader)
    end
    
  end
end