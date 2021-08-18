class UserCourseSubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_course_subject, :user_course_subject_params
  before_action :correct_user
  before_action :course_cancel?
  before_action :subject_inprogress?, :first_subject_start?

  def update
    if @user_course_subject.update user_course_subject_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end

    redirect_back fallback_location: user_course_path
  end

  private
  def user_course_subject_params
    subject_params = params.permit UserCourseSubject::USER_COURSE_SUBJECT_PARAMS
    if @user_course_subject.start? && params[:status] == "inprogress"
      start_time_params = {start_time: Time.current}
      return subject_params.merge start_time_params
    end
    subject_params
  end

  def load_user_course_subject
    @user_course_subject = UserCourseSubject.find_by id: params[:id]
    return if @user_course_subject

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def correct_user
    condition = current_user.id == @user_course_subject.user_course.user_id ||
                current_user.admin? || current_user.supervisor?
    return if condition

    flash[:danger] = t "wrong_user"
    redirect_back fallback_location: user_course_path
  end

  def subject_inprogress?
    is_inprogress = @user_course_subject.inprogress? ||
                    params[:status] == "inprogress"
    return if is_inprogress

    flash[:danger] = t "subject_must_inprogress"
    redirect_back fallback_location: user_course_path
  end

  def course_cancel?
    return unless @user_course_subject.user_course.canceled?

    flash[:danger] = t "course_canceled"
    redirect_back fallback_location: user_course_path
  end

  def first_subject_start?
    start_condition = @user_course_subject.start? &&
                      params[:status] == "inprogress" &&
                      !@user_course_subject.first_subject?

    return unless start_condition

    flash[:info] = t ".first_subject"
    redirect_back fallback_location: user_course_path
  end
end
