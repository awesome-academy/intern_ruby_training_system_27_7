class UserCoursesController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor, except: %i(index show)
  before_action :correct_user, except: %i(index show)
  before_action :load_user_course, only: %i(show destroy)

  def index
    @user_courses = current_user.user_courses.page(params[:page])
                                .per Settings.course_index_page
  end

  def create
    params = user_course_params
    @course = Course.find_by id: params[:course_id]
    begin
      if @course.update user_ids: (@course.user_ids << params[:user_id]).flatten
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".failed"
      end
    rescue ActiveRecord::RecordNotUnique
      flash[:danger] = t ".user_in_course"
    end

    redirect_back fallback_location: courses_url
  end

  def show
    @user_subjects = @user_course.user_course_subjects
                                 .order_by(:created_at, :asc)
                                 .page(params[:page])
                                 .per Settings.course_show_page
    @course_users = @user_course.course.user_courses.page(params[:page])
                                .per Settings.course_show_page
  end

  def destroy
    if @user_course.destroy
      flash[:success] = t "user_course_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_back fallback_location: course_url
  end

  private
  def user_course_params
    params.require(:user_course).permit UserCourse::USER_COURSE_PARAMS
  end

  def load_user_course
    @user_course = UserCourse.find_by id: params[:id]
    return if @user_course

    flash[:danger] = t "insufficient_privileges"
    redirect_to root_path
  end
end
