class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor, only: %i(new create destroy)
  before_action :load_subjects, only: %i(new create show)
  before_action :load_course, only: %i(show destroy)
  before_action :load_trainees, :load_supervisors, only: %i(new create show)

  def index
    @courses = Course.page(params[:page]).per Settings.course_index_page
  end

  def new
    @course = Course.new
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

    flash[:danger] = t "insufficient_privileges"
    redirect_to root_path
  end

  def load_trainees
    @trainees = User.trainee.get_name
  end

  def load_supervisors
    @supervisors = User.supervisor.get_name
  end
end
