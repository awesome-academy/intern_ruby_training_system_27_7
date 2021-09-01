class CourseSubjectTasksController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_course_subject_task, only: :destroy

  def create
    @course_subject_task = CourseSubjectTask.new course_subject_task_params
    if @course_subject_task.save
      flash[:success] = t ".created_successfully"
    else
      flash[:danger] = t ".created_failed"
    end
    redirect_back fallback_location: courses_path
  end

  def destroy
    if @course_subject_task.destroy
      flash[:success] = t "course_subject_task_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_back fallback_location: course_path
  end

  private
  def course_subject_task_params
    params.require(:course_subject_task)
          .permit CourseSubjectTask::COURSE_SUBJECT_TASKS_PARAMS
  end

  def load_course_subject_task
    @course_subject_task = CourseSubjectTask.find_by id: params[:id]
    return if @course_subject_task

    flash[:danger] = t "not_found"
    redirect_back fallback_location: course_path
  end
end
