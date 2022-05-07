class Stock < ApplicationRecord
	
	def self.new_lookup(ticker_sym) 

		client = IEX::Api::Client.new(
		  publishable_token: "pk_b57058a8feac469496f69b1eaf7e8db9",
		  secret_token: 'secret_token',
		  endpoint: 'https://cloud.iexapis.com/v1'
		)
		quote = client.quote(ticker_sym)
		begin 
			new(ticker: ticker_sym,name: client.company(ticker_sym).company_name,last_price: quote.latest_price)
		rescue => exception
			return nil
		end
	end


end
