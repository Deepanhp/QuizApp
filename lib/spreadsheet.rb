class Spreadsheet
	#constants
	DEFAULT_SCORE = 1
	HEADER_ROW = 5
	START_ROW = 6
	QUESTION_COLUMN = 2
	ANSWER_COLUMN = 7
	SCORE_COLUMN = 8
	STATUS_COLUMN = 9
	STATUS_MESSAGE_COLUMN = 10
		
	def self.run

		# Authenticate a session with your Service Account
		session = GoogleDrive::Session.from_service_account_key("client_secret.json")

		# Get the spreadsheet by its title
		spreadsheet = session.spreadsheet_by_title("Quiz upload")
		# Get the first worksheet
		worksheet = spreadsheet.worksheets.first
		# Validate presence of quiz name
		quiz_name = worksheet["B1"]
		quiz_category = worksheet["B2"]
		begin
			@quiz = Quiz.create!(name: quiz_name +" - #{Date.today.to_s}")
			# iterate each row and upload data
			(START_ROW..worksheet.rows.count).each do |row|
				begin
					question = worksheet[row, QUESTION_COLUMN]
					score = worksheet[row, SCORE_COLUMN] || DEFAULT_SCORE
					question = Question.create!(questions: question, score: score)
					question.quizzes << @quiz
					(1..4).each do |index|
						is_answer = (worksheet[HEADER_ROW, index + 2] == worksheet[row, ANSWER_COLUMN])
						Option.create!(opt_name: worksheet[row, index + 2], question_id: question.id, is_answer: is_answer)
					end
					worksheet[row, STATUS_COLUMN] = "Success"
					worksheet.save
				rescue Exception => e
					worksheet[row, STATUS_COLUMN] = "Failed"
					worksheet[row, STATUS_MESSAGE_COLUMN] = e.message
					worksheet.save
					next
				end
			end
		rescue Exception => e
			worksheet.set_background_color(1, 2, 1, 1, GoogleDrive::Worksheet::Colors::DARK_RED_1)
			worksheet[1, 3] = e.message
			worksheet.save
		end
	end
end
