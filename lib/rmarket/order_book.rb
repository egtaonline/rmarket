module RMarket
  class OrderBook
    attr_reader :asset_label
    
    def initialize(asset_label="")
      @buy_ledger = OrderLedger.new("buy", asset_label)
      @sell_ledger = OrderLedger.new("sell", asset_label)
      @asset_label = asset_label
    end
    
    def matches?(order)
      return false if order.asset_label != @asset_label
      if order.type == "buy"
        return false if @sell_ledger.outstanding_order_count == 0 || ask > order.price
      else
        return false if @buy_ledger.outstanding_order_count == 0 || bid < order.price
      end
      true
    end
    
    def submit_order(order)
      raise "Asset label of order does not match OrderBook" if order.asset_label != @asset_label
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

    def bid_quantity; @buy_ledger.bid_quantity; end
    def ask_quantity; @sell_ledger.ask_quantity; end

    def remove_prior_orders(trader)
      @buy_ledger.remove_prior_orders(trader)
      @sell_ledger.remove_prior_orders(trader)
    end
    
    def snapshot
      {"asset_label" => @asset_label, "bid" => bid, "bid_quantity" => bid_quantity, "ask" => ask, "ask_quantity" => ask_quantity}
    end
  end
end