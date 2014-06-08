require 'spec_helper'

describe Reservation do

	let(:user) { FactoryGirl.create(:user) }
	let(:lesson) { FactoryGirl.create(:lesson) }
	before {
		@reservation = user.reservations.build(lesson_id:lesson.id)
	}

	subject { @reservation }

	describe "accessible attributes" do
		it "should not be allow access to user_id" do
			expect do
				Reservation.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error) 
		end
	end

end
