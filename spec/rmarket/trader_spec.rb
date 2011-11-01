require 'spec_helper'

module RMarket
  describe Trader do
    describe "#update_account" do
      before(:each) { @trader = Trader.new; @trader.update_account(200, -1, "IBM") }
      it { @trader.cash.should == 200 }
      it { @trader.shares.should == {"IBM" => -1} }
    end
  end
end