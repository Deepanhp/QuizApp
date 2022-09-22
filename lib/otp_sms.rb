module OtpSms
	class << self
		def send_otp(otp_code, phone_number)
			require 'uri'
			require 'net/http'

			url = URI("https://www.fast2sms.com/dev/bulkV2")

			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			request = Net::HTTP::Post.new(url)
			request["authorization"] = "0tpq2rUKnVNeJ1hBZDazGgFHM6WulbIk34R95OCmYcyLjAvxETI7GrnfMWFsQwKJRAzj8aPV4iX01hDq"
			request.body = "variables_values=#{otp_code}&route=otp&numbers=#{phone_number}"

			response = http.request(request)
			JSON.parse(response.body)
		end
	end
end