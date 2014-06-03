require 'spec_helper'

describe Lesson do

	before {
		@lesson = Lesson.new(name:"Guitar for Biginners", start:Time.now, ending:Time.now + 2.hours)
	}
	subject { @lesson }

	it { should respond_to(:name) }
	it { should respond_to(:start) }
	it { should respond_to(:ending) }

	describe "when name is empty" do
		before { @lesson.name = "" }
		it { should_not be_valid }
	end

	describe "when start time is empty" do
		before { @lesson.start = nil }
		it { should_not be_valid }
	end

	describe "when end time is empty" do
		before { @lesson.ending = nil }
		it { should_not be_valid }
	end

	describe "when start time is later then ending time" do
		before {
			@lesson.start = @lesson.ending + 3.hours
		}
		it { should_not be_valid }
	end
end
