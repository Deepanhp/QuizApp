class Question < ApplicationRecord
	has_and_belongs_to_many :quizzes
	has_many :options, :dependent => :destroy
	validates :questions, presence: true, length: {minimum: 3, maximum: 60}
	validates_uniqueness_of :questions, message: "has already present in database!"
	validates :score, presence: true
end