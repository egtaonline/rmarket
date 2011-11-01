require 'spec_helper'

module RMarket
  describe OrderLedger do
    describe "#submit_order" do
      context "empty order ledger" do
        before(:each) { @order_ledger = OrderLedger.new }
        
        context "incoming buy order" do
          before(:each) { @order_ledger.submit_order(Order.new("buy", 1.5)) }
          
          it "should have 1 order" do
            @order_ledger.outstanding_order_count.should == 1
          end
          it "should have a bid equal to the price of that order" do
            @order_ledger.bid.should == 1.5
          end
          it "should implicitly become a buy ledger" do
            lambda{ @order_ledger.ask }.should raise_error("OrderLedger is of type \"buy\" and cannot supply an \"ask\"")
          end
        end
      end
    end
  end
end