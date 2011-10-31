module RMarket
  class OrderLedger
    
    def initialize(type=nil)
      @orders = []
      @type = type
    end
    
    def submit_order(order)
      remove_prior_orders(order.trader)
      add_order(order)
    end
    
    def outstanding_order_count
      @orders.size
    end

    def bid
      raise "OrderLedger is of type \"sell\" and cannot supply an \"bid\"" if @type == "sell"
      @orders.first
    end

    def ask
      raise "OrderLedger is of type \"buy\" and cannot supply an \"ask\"" if @type == "buy"
      @orders.first
    end

    private
    
    def add_order(order)
      if @orders == []
        @type ||= order.type
        @orders << order
      else
        @orders.insert(@orders.index{|i| i.price > order.price}, order)
      end
    end
    
    def remove_prior_orders(trader)
      @orders.reject!{|x| x.trader == trader}
    end
  end
end