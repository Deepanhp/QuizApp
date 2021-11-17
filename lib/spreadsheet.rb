require 'bundler'
require 'pry'
Bundler.require

# Authenticate a session with your Service Account
session = GoogleDrive::Session.from_service_account_key("client_secret.json")

# Get the spreadsheet by its title
spreadsheet = session.spreadsheet_by_title("Quiz upload")
# Get the first worksheet
worksheet = spreadsheet.worksheets.first
# Validate presence of quiz name
quiz_name = worksheet["B1"]
quiz_category = worksheet["B2"]
unless quiz_name.present?
	worksheet["C1"] = "Upload failed. Quiz name cannot be blank"
	worksheet.save and return

end

@quiz = Quiz.create!(name: quiz_name)
# iterate each row and upload data
(5..worksheet.rows.count).each do |row|
	begin
		question_row = worksheet[row, 2]
		score_row = worksheet[row, 8] || 1
		question = Question.create!(questions: question_row, score: score_row)
		(1..4).each do |index|
			is_answer = (worksheet[row, index+2] == worksheet[row, 7])
			Option.create!(opt_name: worksheet[row, index+2], question_id: question, is_answer: is_answer)
		end
	rescue Exception => e
		worksheet[row, 10] = e.errors.full_messages
		next
	end
end
