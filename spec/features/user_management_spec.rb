require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers


feature "User signs up" do

	scenario "when being a new user visiting the site" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
	end

	scenario "with an email that is already registered" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect{ sign_up }.to change(User, :count).by(0)
		expect(page).to have_content("Email is already taken")
	end
	
	#forgotten password

	# scenario 'user requests password reset' do
	# 	visit '/sessions/forgot_password'
	# 	fill_in :email, :with => 'test@test.com'
	# 	click_button 'Submit'	
	# 	#expect password token for that password is in database
	# 	expect(user.password_token).to change{User.first(:emai => test@test.com).password_token}
	# end

	# scenario 'user can change password' do
	# 	user visits link
	# 	form that asks for new password and password confirmation
	# 	expect password digest to change

	# 	vist '/'
	# 	user = User.first(:email => "test@test.com")
	# 	initial_password_digest = user.password_digest
	# 	request_token("test@test.com")
	# 	user = User.first
	# 	visit "/sessions/change_password/#{user.password_token}"
	# 	fill_in :new_password, :with => "1234"
	# 	fill_in :password_confirmation, :with => "1234"
	# 	click_button 'Submit'
	# 	user = User.new
	# 	new_password_digest = user.password_digest
	# 	puts User.first(:email => "test@test.com").password_digest
	# 	expect(initial_password_digest).not_to eq new_password_digest
	# end

end