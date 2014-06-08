require 'spec_helper'

describe Reservation do

	let(:user) { FactoryGirl.create(:user) }
	let(:lesson) { FactoryGirl.create(:lesson) }
	let(:bass) { BandPartType::BASS }
	before {
		@reservation = user.reservations.build(lesson_id:lesson.id, part_type:bass.value)
	}

	subject { @reservation }

	it { should be_part_type_bass }
	it { should_not be_part_type_sax }

	describe "accessible attributes" do
		it "should not be allow access to user_id" do
			expect do
				Reservation.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error) 
		end
	end

end
