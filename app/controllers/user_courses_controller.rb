class UserCoursesController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor
  before_action :load_user_course, only: :destroy

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
