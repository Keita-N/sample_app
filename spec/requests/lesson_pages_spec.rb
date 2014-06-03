require 'spec_helper'

describe "Lesson Pages" do

	let(:user) { FactoryGirl.create(:user) }
	subject { page }

	describe "index" do
		let(:lesson) { FactoryGirl.create(:lesson) }

		before do
			sign_in user
			visit lessons_path
		end

		it { should have_title "All Lessons" }
		it { should have_selector "h1", text:"All Lessons" }

		describe "pagination" do
			before(:all) { 50.times { |i| FactoryGirl.create(:lesson) }}
			after(:all) { Lesson.delete_all }

			it { should have_selector 'div.pagination' }
			it "should list each lesson" do
				Lesson.paginate(page: 1) do |lesson|
					page.should have_selector 'li', text:lesson.name
				end
			end
		end		
	end

	describe "show" do
		let(:lesson) { FactoryGirl.create(:lesson) }
		before do
			sign_in user
			visit lesson_path(lesson)
		end

		it { should have_title lesson.name }
		it { should have_selector 'h1', text:lesson.name }
		it { should have_selector 'h2', text:"Time: #{lesson.start} ~ #{lesson.ending}"}
	end

	describe "edit" do
		
	end
end