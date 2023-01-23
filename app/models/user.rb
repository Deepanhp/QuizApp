class User < ApplicationRecord
	has_many :submissions, :dependent => :destroy
	before_save { self.email = email.downcase }
	validates :username, presence: true, uniqueness: { case_sensitive: false },	length: { minimum: 3, maximum: 25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 105 },	uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
	validates :password, length: {minimum: 4}, :if => :password
	has_secure_password

	def quiz_already_taken(quiz_id)
		self.submissions.where(quiz_id: quiz_id, submitted: true).any?
	end
end