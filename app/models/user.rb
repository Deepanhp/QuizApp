class User < ApplicationRecord
	has_many :submissions, :dependent => :destroy
	before_save { self.email = email.downcase }
	validates :username, presence: true, uniqueness: { case_sensitive: false },	length: { minimum: 3, maximum: 25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_PHONE_REGEX = /[0-9]/
	validates :phone, presence: true,	length: { minimum: 10, maximum: 10 }, format: { with: VALID_PHONE_REGEX }
	validates :email, presence: true, length: { maximum: 105 },	uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
	validates :password, length: {minimum: 4}, :if => :password
	has_secure_password
	has_one_time_password
	attr_accessor :otp
end