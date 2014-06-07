class LessonsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only:[:destroy, :create, :edit]

	def index
		@lessons = Lesson.paginate(page: params[:page])
	end

	def create
		@lesson = Lesson.new(params[:lesson])
		if @lesson.save
			flash[:success] = 'Lesson created'
			redirect_to lessons_url
		else
			render 'new'
		end
	end

	def new
		@lesson = Lesson.new
	end

	def show
		@lesson = Lesson.find(params[:id])
	end

	def edit
		@lesson = Lesson.find(params[:id])
	end

	def update
		@lesson = Lesson.find(params[:id])
		if @lesson.update_attributes(params[:lesson])
			flash[:success] = 'Lesson updated'
			redirect_to @lesson
		else
			render 'edit'
		end
	end

	def destroy
		lesson = Lesson.find(params[:id])
		lesson.destroy
		flash[:success] = "Lesson destroyed."
		redirect_to lessons_url
	end
end
