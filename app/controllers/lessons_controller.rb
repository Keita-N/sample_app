class LessonsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only:[:destroy]

	def index
		@lessons = Lesson.paginate(page: params[:page])
	end

	def show
		@lesson = Lesson.find(params[:id])
	end

	def edit
	end

	def destroy
		lesson = Lesson.find(params[:id])
		lesson.destroy
		flash[:success] = "Lesson destroyed."
		redirect_to "index"
	end
end
