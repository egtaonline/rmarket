require 'spec_helper'
require 'gslng'

module RMarket
  module Beliefs
    describe NewsGenerator do
      describe "#generate_news" do
        before(:each) { @news_g = NewsGenerator.new(GSLng::RNG::Gaussian.new(1, 1)); @news = @news_g.generate_news(0.2, 4) }
        it { @news_g.noise_mean.should == 1}
        it { @news_g.noise_std.should == 1}
        it { @news.is_a?(News).should == true }
        it { @news.signal.should_not == 0.2 }
        it { @news.previous_dividend.should == 4}
      end
    end
    describe DividendGenerator do
      let!(:div_g){DividendGenerator.new(GSLng::RNG::Gaussian.new(1, 1))}
      it {div_g.dividend_mean.should == 1}
      it {div_g.dividend_std.should == 1}
    end
  end
end