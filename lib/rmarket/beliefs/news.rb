module RMarket
  module Beliefs
    # Piece of news patterned after Epstein-Schneider 2008
    class News
      attr_reader :signal, :previous_dividend
  
      def initialize(signal, previous_dividend=nil)
        @signal = signal
        @previous_dividend = previous_dividend
      end
    end

    # noise in news perturbs the next period dividend shock
    class NewsGenerator

      def noise_mean; @noise_distribution.mu; end
      def noise_std; @noise_distribution.sigma; end
  
      def initialize(noise_distribution)
        @noise_distribution = noise_distribution
      end
  
      def generate_news(next_shock, last_dividend)
        News.new(@noise_distribution.sample+next_shock, last_dividend)
      end
    end

    # Mean reverting dividend generation
    class DividendGenerator

      attr_reader :kappa, :last_period_dividend
      def dividend_mean; @dividend_distribution.mu; end
      def dividend_std; @dividend_distribution.sigma; end
  
      def initialize(dividend_distribution, kappa=0)
        @dividend_distribution, @kappa = dividend_distribution, kappa
        @next_period_dividend = dividend_mean
      end
  
      def generate_next_dividend
        @next_shock = @dividend_distribution.sample
        @last_period_dividend = @next_period_dividend
        @next_period_dividend = (dividend_mean*@kappa)+((1-@kappa)*@next_period_dividend)+next_shock
      end
    end
  end
end