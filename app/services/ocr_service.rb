require 'pry'
class OcrService < BaseService
	attr_reader :file_path, :options, :text_array

	def initialize(file_path, options)
		@file_path = file_path
		@options = options
	end

	def run
		runs(:validate_options,
				 :extract_text
				)
	end

	def validate_options
		unless options[:start_word] && options[:end_word]
			errors.add(:base, "Start word or End word is missing!")
		end
	end

	def extract_text
		begin
			file = RTesseract.new(file_path)
			text = file.to_s
			# Remove header
			text = text.split(options[:start_word])
			text.slice!(0)
			text = text.join
			# Remove footer
			text = text.split(options[:end_word])
			text.slice!(-1)
			text = text.join
			@text_array = text.split("\n").reject(&:blank?)
		rescue Exception => e
			errors.add(:base, e.message)
		end
	end
end
 