class CreateQuiz < BaseService
	attr_reader :text

	RULES = {
						question_flag: "1)",
						opt1_flag: "2)",
						opt2_flag: "3)",
						opt3_flag: "4)",
						opt4_flag: "only current element"
					}

	def initialize(text, options)
		@text = text
		# include exclude_list
		@options = options
	end

	def run
		runs(:validate_text,
				 :generate_quiz
				)
	end

	def validate_text
		if text.blank?
			errors.add(:base, "Cannot process blank text")
		end
		if options[:quiz_name].blank?
			errors.add(:base, "Quiz name cannot be blank")
		end
	end

	def generate_quiz
		series = [:question_flag, :opt1_flag, :opt2_flag, :opt3_flag, :opt4_flag].cycle
		$current = series.next
		# quiz = Quiz.create!(name: options[:quiz_name] +" - #{Date.today.to_s}")
		data = {}
		text.each_with_index do |t, index|
			case $current
			when :question_flag
				data[:question].present? ?  (data[:question] << t) : (data[:question] = t)
			when :opt1_flag
				data[:opt1_flag].present? ?  (data[:opt1_flag] << t) : (data[:opt1_flag] = t)
			when :opt2_flag
				data[:opt2_flag].present? ?  (data[:opt2_flag] << t) : (data[:opt2_flag] = t)
			when :opt3_flag
				data[:opt3_flag].present? ?  (data[:opt3_flag] << t) : (data[:opt3_flag] = t)
			when :opt4_flag
				data[:opt4_flag].present? ?  (data[:opt4_flag] << t) : (data[:opt4_flag] = t)
			end
			if text[index+1].include? RULES[series.peek]
				$current = series.next
			end
		end

	end
end