class Quiz < ApplicationRecord
	has_many :questions, :dependent => :destroy
	has_many :quiz_categories
	has_many :submissions, :dependent => :destroy
  has_many :categories, through: :quiz_categories
	validates :name, uniqueness: true, presence: true, length: {minimum: 3, maximum: 30}
end