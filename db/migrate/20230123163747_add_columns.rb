class AddColumns < ActiveRecord::Migration[5.1]
    def change
      add_column :submissions, :submitted, :boolean
      add_column :quizzes, :duration, :integer
    end
  end
  
