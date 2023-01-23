class AddColumns < ActiveRecord::Migration[7.0]
    def change
      add_column :submissions, :submitted, :boolean
      add_column :quizzes, :duration, :integer
    end
  end
  