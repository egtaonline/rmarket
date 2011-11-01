module RMarket
  class OrderLedger
    
    def initialize(type=nil, asset_label="")
      @orders = []
      @type = type
      @asset_label = asset_label
    end
    
    def transact(order)
      while order.quantity > 0 && price != 0 && price != 1/0.0
        if @type == "buy" && order.type == "sell"
          if bid > order.price
            if @orders.last.quantity > order.quantity
              @orders.last.trader.update_account(-bid*order.quantity, order.quantity, @asset_label)
              order.trader.update_account(bid*order.quantity, -order.quantity, @asset_label)
              @orders.last.quantity -= order.quantity
              return nil
            else
              @orders.last.trader.update_account(-bid*@orders.last.quantity, @orders.last.quantity, @asset_label)
              order.trader.update_account(bid*@orders.last.quantity, -@orders.last.quantity, @asset_label)
              order.quantity -= @orders.last.quantity
              @orders.pop
              return nil if order.quantity == 0
            end
          else
            return order
          end
        elsif @type == "sell" && order.type == "buy"
          if ask < order.price
            if @orders.first.quantity > order.quantity
              @orders.first.trader.update_account(ask*order.quantity, -order.quantity, @asset_label)
              order.trader.update_account(-ask*order.quantity, order.quantity, @asset_label)
              @orders.first.quantity -= order.quantity
              return nil
            else
              @orders.first.trader.update_account(ask*@orders.first.quantity, -@orders.first.quantity, @asset_label)
              order.trader.update_account(-ask*@orders.first.quantity, @orders.first.quantity, @asset_label)
              order.quantity -= @orders.first.quantity
              @orders.delete_at(0)
              return nil if order.quantity == 0
            end
          else
            return order
          end
        else
          raise "Orders of the same type cannot transact"
        end
      end
      return order
    end
    
    def submit_order(order)
      @type ||= order.type
      index = @orders.index{|i| i.price > order.price}
      index == nil ? @orders << order : @orders.insert(index, order)
    end
    
    def outstanding_order_count; @orders.size; end

    def bid
      raise "OrderLedger is of type \"sell\" and cannot supply a \"bid\"" if @type == "sell"
      @orders == [] ? 0 : @orders.last.price
    end
    
    def bid_quantity
      raise "OrderLedger is of type \"sell\" and cannot supply a \"bid\"" if @type == "sell"
      @orders == [] ? 0 : @orders.last.quantity
    end

    def ask
      raise "OrderLedger is of type \"buy\" and cannot supply an \"ask\"" if @type == "buy"
      @orders == [] ? 1/0.0 : @orders.first.price
    end
    
    def ask_quantity
      raise "OrderLedger is of type \"buy\" and cannot supply an \"ask\"" if @type == "buy"
      @orders == [] ? 0 : @orders.first.quantity
    end
    
    def remove_prior_orders(trader);  @orders.reject!{|x| x.trader == trader}; end
    
    private
    
    def price
      @type == "buy" ? bid : ask
    end
  end
end