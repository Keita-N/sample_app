class LessonsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show]

	def index
		@lessons = Lesson.paginate(page: params[:page])
	end

	def show
		@lesson = Lesson.find(params[:id])
	end
end
