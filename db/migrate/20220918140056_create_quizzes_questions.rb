class CreateQuizzesQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions_quizzes do |t|
      t.references :quiz, foreign_key: true
      t.references :question, foreign_key: true
    end
  end
end
