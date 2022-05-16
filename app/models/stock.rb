class Stock < ApplicationRecord
	
	has_many :user_stocks
	has_many :users, through: :user_stocks

	validates (:name,:ticker, presence: true)
	

	def self.new_lookup(ticker_sym) 
		client = IEX::Api::Client.new(
		  publishable_token: "pk_b57058a8feac469496f69b1eaf7e8db9",
		  secret_token: 'secret_token',
		  endpoint: 'https://cloud.iexapis.com/v1'
		)
		
		begin 
			quote = client.quote(ticker_sym)
			new(ticker: ticker_sym,name: client.company(ticker_sym).company_name,last_price: quote.latest_price)
		rescue => exception
			return nil
		end
	end


	# Method to tkae historical prices and dates 
	def self.take_historical(ticker_sym)
		client = IEX::Api::Client.new(
		  publishable_token: "pk_b57058a8feac469496f69b1eaf7e8db9",
		  secret_token: 'secret_token',
		  endpoint: 'https://cloud.iexapis.com/v1'
		)

		historical_prices = client.historical_prices(ticker_sym)
		# 1 Month dates added to @dates array
		@dates = Array.new
		historical_prices.each do |price|
			@dates << price.date
		end
		# 1 Month price added to @prices array
		@prices = Array.new 
		historical_prices.each do |price|
			@prices << price.open
		end

		#hash to return @prices and @dates in the same time 
		@datesAndPricesArray = @dates.zip(@prices) 

		#convert two array to hash as key value 

		return @datesAndPricesArray

	end

	

	# method to check whether stock exist or not in db 
	def self.check_db(ticker_sym)
		where(ticker: ticker_sym).first
	end
	

end
