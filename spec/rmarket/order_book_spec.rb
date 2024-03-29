require 'spec_helper'

module RMarket
  describe OrderBook do
    describe "#matches?" do
      before(:each) { @order_book = OrderBook.new }
      it "should never match if empty" do
        for i in 1..10 do
          @order_book.matches?(Order.new("buy", i)).should == false
          @order_book.matches?(Order.new("sell", i)).should == false
        end
      end
      it "should match if a buy order has a price higher than ask" do
        @order_book.submit_order(Order.new("sell", 1.5))
        @order_book.matches?(Order.new("buy", 1.7)).should == true
      end
      it "should match if a sell order has a price lower than bid" do
        @order_book.submit_order(Order.new("buy", 1.5))
        @order_book.matches?(Order.new("sell", 1.3)).should == true
      end
    end
    
    describe "#submit_order" do
      context "empty order book" do
        before(:each) { @order_book = OrderBook.new }
        it "should raise error if order doesn't match asset type" do
          lambda{ @order_book.submit_order(Order.new("buy", 1.5, nil, 1, "fasd"))}.should raise_error("Asset label of order does not match OrderBook")
        end
        
        context "incoming buy order" do
          before(:each) { @order_book.submit_order(Order.new("buy", 1.5)) }
          it "should have 1 buy order" do
            @order_book.outstanding_bid_count.should == 1
          end
          it "should have a bid equal to the price of that order" do
            @order_book.bid.should == 1.5
          end
        end
        
        context "incoming sell order" do
          before(:each) { @order_book.submit_order(Order.new("sell", 1.5)) }
          it "should have 1 sell order" do
            @order_book.outstanding_ask_count.should == 1
          end
          it "should have an ask equal to the price of that order" do
            @order_book.ask.should == 1.5
          end
        end
        
        context "order book has existing buy order from trader A" do
          before(:each) do
            @order_book = OrderBook.new
            @traderA = double('trader')
            @traderB = double('trader')
            @order_book.submit_order(Order.new("buy", 1.5, @traderA))
          end
          
          context "incoming buy order is higher" do
            before(:each) { @order_book.submit_order(Order.new("buy", 1.7, @traderB)) }
            it "should have 2 buy orders" do
              @order_book.outstanding_bid_count.should == 2
            end
            it "should have a bid equal to the price of that order" do
              @order_book.bid.should == 1.7
            end
          end
          
          context "incoming buy order is lower" do
            before(:each) { @order_book.submit_order(Order.new("buy", 1.3, @traderB)) }
            it "should have 2 buy orders" do
              @order_book.outstanding_bid_count.should == 2
            end
            it "should have a bid equal to the price of the prior order" do
              @order_book.bid.should == 1.5
            end
          end
          
          context "incoming sell order is higher" do
            before(:each) { @order_book.submit_order(Order.new("sell", 1.7, @traderB)) }
            it "should have 1 buy order" do
              @order_book.outstanding_bid_count.should == 1
            end
            it "should have 1 sell order" do
              @order_book.outstanding_ask_count.should == 1
            end
            it "should have a bid equal to the price of the prior order" do
              @order_book.bid.should == 1.5
            end
            it "should have an ask equal to the price of that order" do
              @order_book.ask.should == 1.7
            end
          end
          
          context "incoming sell order is lower" do
            before(:each) do
              @traderA.should_receive("update_account").with(-1.5, 1, "")
              @traderB.should_receive("update_account").with(1.5, -1, "")
              @order_book.submit_order(Order.new("sell", 1.3, @traderB))
            end
            
            it "should have 0 buy orders" do
              @order_book.outstanding_bid_count.should == 0
            end
            it "should have 0 sell orders" do
              @order_book.outstanding_ask_count.should == 0
            end
            it "should have a bid equal to that of an empty order book" do
              @order_book.bid.should == 0
            end
            it "should have an ask equal to that of an empty order book" do
              @order_book.ask.should == 1/0.0
            end
          end
        end
        
    
        context "order book has existing sell order from trader A" do
          before(:each) do
            @order_book = OrderBook.new
            @traderA = double('trader')
            @traderB = double('trader')
            @order_book.submit_order(Order.new("sell", 1.5, @traderA))
          end
          
          context "incoming buy order is higher" do
            before(:each) do
              @traderA.should_receive("update_account").with(1.5, -1, "")
              @traderB.should_receive("update_account").with(-1.5, 1, "")
              @order_book.submit_order(Order.new("buy", 1.7, @traderB))
            end
            it "should have 0 buy orders" do
              @order_book.outstanding_bid_count.should == 0
            end
            it "should have 0 sell orders" do
              @order_book.outstanding_ask_count.should == 0
            end
            it "should have a bid equal to that of an empty order book" do
              @order_book.bid.should == 0
            end
            it "should have an ask equal to that of an empty order book" do
              @order_book.ask.should == 1/0.0
            end
          end
          
          context "incoming buy order is lower" do
            before(:each) { @order_book.submit_order(Order.new("buy", 1.3, @traderB)) }
            it "should have 1 buy order" do
              @order_book.outstanding_bid_count.should == 1
            end
            it "should have 1 sell order" do
              @order_book.outstanding_bid_count.should == 1
            end
            it "should have a bid equal to the price of the new order" do
              @order_book.bid.should == 1.3
            end
            it "should have a ask equal to the price of the prior order" do
              @order_book.ask.should == 1.5
            end
          end
          
          context "incoming sell order is higher" do
            before(:each) { @order_book.submit_order(Order.new("sell", 1.7, @traderB)) }
            it "should have 0 buy orders" do
              @order_book.outstanding_bid_count.should == 0
            end
            it "should have 2 sell orders" do
              @order_book.outstanding_ask_count.should == 2
            end
            it "should have a ask equal to the price of the prior order" do
              @order_book.ask.should == 1.5
            end
          end
          
          context "incoming sell order is lower" do
            before(:each) do
              @order_book.submit_order(Order.new("sell", 1.3, @traderB))
            end
            
            it "should have 0 buy orders" do
              @order_book.outstanding_bid_count.should == 0
            end
            it "should have 2 sell orders" do
              @order_book.outstanding_ask_count.should == 2
            end
            it "should have a bid equal to that of an empty order book" do
              @order_book.bid.should == 0
            end
            it "should have an ask equal to the price of the new order" do
              @order_book.ask.should == 1.3
            end
          end
        end
        context "order book has existing buy order from trader A for multiple units" do
          before(:each) do
            @order_book = OrderBook.new("IBM")
            @traderA = double('trader')
            @traderB = double('trader')
            @order_book.submit_order(Order.new("buy", 1.5, @traderA, 2, "IBM"))
          end
          
          context "incoming matching sell order for 1" do
            before(:each) do
              @traderA.should_receive("update_account").with(-1.5, 1, "IBM")
              @traderB.should_receive("update_account").with(1.5, -1, "IBM")
              @order_book.submit_order(Order.new("sell", 1.4, @traderB, 1, "IBM"))
            end
            it "should have 1 buy order" do
              @order_book.outstanding_bid_count.should == 1
            end
            it "should have 1 unit in that buy order" do
              @order_book.bid_quantity.should == 1
            end
            it "should have bid equal to the price of the prior order" do
              @order_book.bid.should == 1.5
            end
          end
          
          context "incoming sell order requests 3 units" do
            before(:each) do
              @traderA.should_receive("update_account").with(-3.0, 2, "IBM")
              @traderB.should_receive("update_account").with(3.0, -2, "IBM")
              @order_book.submit_order(Order.new("sell", 1.4, @traderB, 3, "IBM"))
            end
            it "should have 0 buy orders" do
              @order_book.bid_quantity.should == 0
            end
            it "should have 1 sell order" do
              @order_book.outstanding_ask_count.should == 1
            end
            it "should have 1 unit in that sell order" do
              @order_book.ask_quantity.should == 1
            end
            it "should have bid price of zero" do
              @order_book.bid.should == 0
            end
            it "should have ask equal to the price of the new order" do
              @order_book.ask.should == 1.4
            end
          end
        end
      end
    end
  end
end