class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor, only: %i(new create destroy)
  before_action :load_subjects, only: %i(new create)
  before_action :load_course, only: %i(show destroy)

  def index
    @courses = Course.page(params[:page]).per Settings.course_index_page
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    @course.course_subjects.each do |c|
      c.duration = c.subject.duration
    end
    return render :new unless @course.save

    flash[:info] = t "success"
    render "static_pages/home"
  end

  def show
    @course_subjects = @course.course_subjects.page(params[:page])
                              .per Settings.course_show_page
  end

  def destroy
    if @course.destroy
      flash.now[:success] = t "course_deleted"
    else
      flash.now[:danger] = t "delete_fail"
    end
    redirect_to courses_url
  end

  private
  def course_params
    new_params = params.require(:course).permit Course::COURSE_PARAMS
    new_params[:subject_ids].shift
    new_params
  end

  def load_subjects
    @subjects = Subject.get_list
  end

  def logged_in_supervisor
    return if current_user.admin? || current_user.supervisor?

    flash[:warning] = t "please_login"
    redirect_to root_url
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:danger] = t "insufficient_privileges"
    redirect_to root_path
  end
end
