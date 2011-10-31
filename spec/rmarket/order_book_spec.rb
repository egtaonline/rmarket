require 'spec_helper'

module RMarket
  describe OrderBook do
    describe "#submit_order" do
      context "empty order book" do
        before(:each) { @order_book = OrderBook.new }
        context "incoming buy order" do
          before(:each) { @order_book.submit_order(Order.new("buy", 1.5)) }
          it "should have 1 buy order" do
            @order_book.buy_orders.size.should == 1
          end
          it "should have a bid equal to the price of that order" do
            @order_book.bid.should == 1.5
          end
        end
      end
    end
  end
end