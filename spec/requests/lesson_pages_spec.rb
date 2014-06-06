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

		it { should_not have_link "edit" }
		it { should_not have_link "delete" }
		it { should_not have_button "New"}

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

	describe "index when admin user" do
		let(:admin) { FactoryGirl.create(:admin) }
		before do
			FactoryGirl.create(:lesson)
			sign_in admin
			visit lessons_path
		end

		it { should have_selector "h1", text:"All Lessons" }
		it { should have_link "edit", href:edit_lesson_path(Lesson.first) }
		it { should have_link "delete", href:lesson_path(Lesson.first) }
		it "should able to delete lesson" do
			expect{ click_link "delete" }.to change(Lesson, :count).by(-1)
		end
		it { should have_link "New Lesson", href:new_lesson_path }
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