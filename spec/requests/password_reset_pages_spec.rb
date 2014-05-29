require 'spec_helper'

describe "Password Reset Page" do
  before do
  	visit root_path
  	visit new_password_reset_path
  end

  subject { page }

  it { should have_title(full_title('Reset Password'))}
  it { should have_selector('h1', text:'Reset Password') }
  it { should have_field('email') }
  it { should have_button('Reset Password') }

  describe "Reset Password" do
  	let(:user) { FactoryGirl.create(:user)}
  	
  	before do
  		fill_in 'email', with:user.email
  		click_button 'Reset Password'
  	end

  	it { should have_title full_title('')}
  	it { should have_content('Email sent with password reset instruction.')}

  	describe "reset info" do
  		it {
  			user.reload.password_reset_token.should_not == nil
  			user.reload.password_reset_sent_at.should_not == nil
  		}
  	end


  end
	
end