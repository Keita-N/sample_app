require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  before do
  	@micropost = user.microposts.build(content:"Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:in_reply_to) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id isn't present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Micropost.new(user_id:user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end

    it "should not allow access to in_reply_to_id" do
      expect do
        Micropost.new(in_reply_to_id:user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end