class AddScoreToSubmission < ActiveRecord::Migration[5.1]
  def change
  	add_column :submissions, :score, :integer
  end
end
