class Stock < ApplicationRecord
	
	has_many :user_stocks
	has_many :users, through: :user_stocks

	validates :name,:ticker, presence: true

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


end
