class ReservationsController < ApplicationController
	before_filter :signed_in_user

	def create
		@lesson = Lesson.find(params[:reservation][:lesson_id])
		current_user.reserve!(@lesson, params[:reservation][:part_type])
		redirect_to @lesson
	end

	def destroy
		@lesson = Reservation.find(params[:id]).lesson
		current_user.cancel!(@lesson)
		redirect_to @lesson
	end
end
