require 'spec_helper'

shared_examples_for "Reset Password Page" do
  it { should have_title(full_title('Reset Password'))}
  it { should have_selector('h1', text:'Reset Password') }
  it { should have_field('email') }
  it { should have_button('Reset Password') }
end

describe "Password Reset Page" do
  before do
  	visit root_path
  	visit new_password_reset_path
  end

  subject { page }

  it_behaves_like "Reset Password Page"

  describe "Reset Password" do
  	let(:user) { FactoryGirl.create(:user)}
  	
  	before do
  		fill_in 'email', with:user.email
  		click_button 'Reset Password'
  	end

  	it { should have_title full_title('')}
  	it { should have_content('Email sent with password reset instruction.')}

  	describe "save reset tokens" do
  		it { user.reload.password_reset_token.should_not == nil }
  		it { user.reload.password_reset_sent_at.should_not == nil }
  	end

  	describe "visit URL in password reset mail" do
  		before {
  			visit edit_password_reset_path(user.reload.password_reset_token)
  		}
  		describe "password reset page" do
	  		it { should have_title(full_title("Input New Password"))}
	  		it { should have_selector('h1', text:"Reset Password") }
	  		it { should have_field('Password') }
	  		it { should have_field('Password Confirmation') }
	  		it { should have_button('Update Password') }
  		end

  		describe "with valid info" do
  			let(:new_password) { "newpassword"}
  			before {
  				fill_in("Password", with:new_password)
  				fill_in("Password Confirmation", with:new_password)
  				click_button("Update Password")
  			}

  			it { should have_title user.name }
	      it { should have_selector('div.alert.alert-notice') }
	      it { should have_link('Sign out', href: signout_path) }
	      specify { user.reload.authenticate(new_password).should be_true }

  		end

  		describe "with invalid info" do
  			before { click_button "Update Password" }

	      it { should have_content('error') }			
  		end
  	end
  end

  describe "when token has been expired" do
      let(:user) { FactoryGirl.create(:expired_reset_token) }
      let(:new_password) { "newpassword"}
      before {        
        visit edit_password_reset_path(user.password_reset_token)
        fill_in("Password", with:new_password)
        fill_in("Password Confirmation", with:new_password)
        click_button("Update Password")
      }

      it_behaves_like "Reset Password Page"
      it { should have_selector "div.alert.alert-error"}
  end

	
end