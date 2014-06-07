require 'spec_helper'

describe "Lesson Pages" do

	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }
	let(:lesson) { FactoryGirl.create(:lesson) }
	
	subject { page }

	describe "index" do

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
		before do
			sign_in user
			visit lesson_path(lesson)
		end
		it { should have_title lesson.name }
		it { should have_selector 'h1', text:lesson.name }
		it { should have_selector 'h2', text:"Time: #{lesson.start} ~ #{lesson.ending}"}
	end

	describe "edit" do
		before do
			sign_in admin
			visit edit_lesson_path lesson
		end

		describe "page" do
			it { should have_title "Edit Lesson"}
			it { should have_selector "h1", text:"Update lesson" }
		end

		describe "with invalid information" do

			describe "when Name is null" do
				before do
					fill_in "Name", with:""
					click_button "Save changes"
				end
  	    it { should have_content('error') }
			end

			describe "when start is after ending" do
				before do
					select "2013", from:"lesson_start_1i"
					select "2012", from:"lesson_ending_1i"
					click_button "Save changes"
				end
				it { should have_content 'error' }
			end
    end

    describe "with valid information" do
      let(:new_name)  { "New Lesson" }
      let(:start) { Time.parse('2014-7-1 15:30') }
      let(:ending) { Time.parse('2014-7-1 17:30') }
      before do
        fill_in "Name",             with: new_name

        select start.year.to_s,		from:"lesson_start_1i"
        within("#lesson_start_2i") do
        	find("option[value='#{start.mon}']").click
        end
        select start.day.to_s,		from:"lesson_start_3i"
        select start.hour.to_s,		from:"lesson_start_4i"
        select start.min.to_s,		from:"lesson_start_5i"

        select ending.year.to_s,	from:"lesson_ending_1i"
        within "#lesson_ending_2i" do
        	find("option[value='#{ending.mon}']").click
        end
        select ending.day.to_s,		from:"lesson_ending_3i"
        select ending.hour.to_s,	from:"lesson_ending_4i"
        select ending.min.to_s,		from:"lesson_ending_5i"
        click_button "Save changes"
      end

      it { should have_title new_name }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { lesson.reload.name.should  == new_name }
      specify { lesson.start == start }
      specify { lesson.ending == ending }
    end
	end

	describe "new" do
		before do
			sign_in admin
			visit lessons_path
			click_link "New Lesson"
		end

		it { should have_title 'New Lesson' }

		describe "with valid information" do
			before do
				fill_in 'Name', with:'New Lesson'
				select '13', from:"lesson_start_4i"
				select '15', from:"lesson_ending_4i"
			end

			it "should create a new lesson" do
				expect{ click_button 'Save' }.to change(Lesson, :count).by(1)
			end

			describe "after saving new lesson" do
				before { click_button 'Save' }
				it { should have_content 'Lesson created' }			
			end
		end

		describe "with invalid information" do
			before { click_button 'Save' }
			it { should have_content 'error' }
		end
	end
end