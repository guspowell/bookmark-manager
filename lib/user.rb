require 'bcrypt'

class User

	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation
	validates_confirmation_of :password
	validates_uniqueness_of :email

	property :id, Serial
	property :email, String
	property :password_digest, Text
	property :email, String, :unique => true
	property :password_token, Text

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)	#find first user with this email address
		if user && BCrypt::Password.new(user.password_digest) == password 		# '==' is different for bycrypt
			user
		else
			nil
		end
	end
end

#everytime you change model (add column) must 'rake auto_upgrade'
# rake auto_upgrade RACK_ENV=test