class CourseSubjectsController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_supervisor
  before_action :load_course_subjects, only: %i(show destroy)

  def show
    @course = @course_subject.course
  end

  def create
    params = course_subjects_params
    @course = Course.find_by id: params[:course_id]

    begin
      if @course && @course.subjects << Subject.find(params[:subject_id])
        flash[:success] = t ".success"
      else
        flash[:danger] = t ".failed"
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t "not_found"
    rescue ActiveRecord::RecordNotUnique
      flash[:danger] = t ".subject_in_course"
    end

    redirect_back fallback_location: courses_path
  end

  def destroy
    if @course_subject.destroy
      flash[:success] = t "course_subject_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_back fallback_location: course_path
  end

  private
  def course_subjects_params
    params.require(:course_subject).permit CourseSubject::COURSE_SUBJECTS_PARAMS
  end

  def load_course_subjects
    @course_subject = CourseSubject.includes(course_subject_tasks: :user_tasks,
      user_course_subjects: :user_tasks).find_by id: params[:id]
    return if @course_subject

    flash[:danger] = t "not_found"
    redirect_to root_path
  end
end
