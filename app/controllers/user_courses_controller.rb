class UserCoursesController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor, except: %i(index show update)
  before_action :load_user_course, except: %i(index create)
  before_action :correct_user, only: %i(update)
  before_action :course_start?, :finish_all_subject?, only: %i(update)

  def index
    @user_courses = current_user.user_courses.includes(:course)
                                .page(params[:page])
                                .per Settings.course_index_page
  end

  def create
    params = user_course_params
    @course = Course.find_by id: params[:course_id]
    begin
      if @course.update user_ids: (@course.user_ids << params[:user_id]).flatten
        flash[:success] = t ".success"
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:danger] = t ".user_in_course"
    rescue StandardError
      flash[:danger] = t ".failed"
    end

    redirect_back fallback_location: courses_path
  end

  def show
    @user_subjects = @user_course.user_course_subjects
                                 .includes(course_subject: :subject)
                                 .order_by(:created_at, :asc)
                                 .page(params[:page])
                                 .per Settings.course_show_page
    @course_users = @user_course.course.user_courses
                                .includes(:user).page(params[:page])
                                .per Settings.course_show_page
  end

  def update
    begin
      if @user_course.update status: params[:status]
        flash[:success] = t ".success"
      end
    rescue StandardError
      flash[:danger] = t ".fail"
    end

    redirect_back fallback_location: user_course_path
  end

  def destroy
    if @user_course.destroy
      flash[:success] = t "user_course_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_back fallback_location: course_path
  end

  private
  def user_course_params
    params.require(:user_course).permit UserCourse::USER_COURSE_PARAMS
  end

  def load_user_course
    @user_course = UserCourse.includes(user_course_subjects: :user_tasks)
                             .find_by id: params[:id]
    return if @user_course

    flash[:danger] = t "not found"
    redirect_to root_path
  end

  def correct_user
    unless current_user.id == @user_course.user_id ||
           current_user.admin? || current_user.supervisor?
      flash[:danger] = t "wrong_user"
      redirect_back fallback_location: user_course_path
    end
  end

  def course_start?
    return if @user_course.start?

    flash[:danger] = t "course_must_start"
    redirect_back fallback_location: user_course_path
  end

  def finish_all_subject?
    not_finished_subject = @user_course.user_course_subjects
                                       .not_status(:finished).count
    return unless params[:status] == "finished" && !not_finished_subject.zero?

    flash[:info] = t ".unfinish"
    redirect_back fallback_location: user_course_path
  end
end
