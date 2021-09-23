class CoursesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_subjects, only: %i(new create show update)
  before_action :load_course, only: %i(show update destroy)
  before_action :load_trainees, :load_supervisors, only: %i(new create show)

  rescue_from ActiveRecord::RecordNotUnique do
    flash[:danger] = t ".not_unique"
    redirect_back fallback_location: courses_path
  end

  rescue_from StandardError do
    flash[:danger] = t ".failed"
    redirect_back fallback_location: courses_path
  end

  def index
    @q = Course.ransack params[:q]
    @q.sorts = Course::SORT_PARAMS if @q.sorts.empty?

    @courses = @q.result.page(params[:page]).per Settings.course_index_page
  end

  def new
    @course = Course.new
    @course.user_courses.new
  end

  def create
    @course = Course.new course_params
    return render :new unless @course.save

    flash[:success] = t "success"
    redirect_to courses_path
  end

  def show
    @course_subjects = @course.course_subjects.order_create.page(params[:page])
                              .per Settings.course_show_page
    @course_users = @course.user_courses.page(params[:page])
                           .per Settings.course_show_page
  end

  def update
    if @course.update course_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end

    redirect_to course_path
  end

  def destroy
    if @course.destroy
      flash[:success] = t "course_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to courses_path
  end

  private
  def course_params
    params.require(:course).permit Course::COURSE_PARAMS
  end

  def load_subjects
    @subjects = Subject.get_list
  end

  def load_course
    @course = Course.includes(Course::COURSE_INCLUDES).find_by id: params[:id]
    return if @course

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def load_trainees
    @trainees = User.trainee.get_name
  end

  def load_supervisors
    @supervisors = User.supervisor.get_name
  end
end
