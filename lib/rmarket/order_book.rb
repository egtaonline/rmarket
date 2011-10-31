module RMarket
  class OrderBook
    def initialize
      @buy_ledger = OrderLedger.new
    end
    
    def submit_order(order)
      if order.type == "buy"
        @buy_ledger.submit_order(order)
      end
    end
  end
end