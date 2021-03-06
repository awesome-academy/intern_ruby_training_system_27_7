class UserReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_report, only: %i(show edit update destroy)
  authorize_resource
  before_action :load_course, except: %i(show destroy)

  def index
    @q = current_user.user_reports.ransack(params[:q])
    @q.sorts = UserReport::SORT_PARAMS if @q.sorts.empty?

    @user_reports = @q.result.includes(:course)
                      .page(params[:page]).per Settings.course_index_page
  end

  def new
    @user_report = UserReport.new
  end

  def create
    @user_report = current_user.user_reports.create report_params
    return render :new unless @user_report.save

    flash[:success] = t "success"
    redirect_to user_reports_path
  end

  def show; end

  def edit; end

  def update
    if @user_report.update report_params
      flash[:success] = t ".updated_success"
      redirect_to user_reports_path
    else
      flash.now[:danger] = t ".updated_fail"
      render :edit
    end
  end

  def destroy
    if @user_report.destroy
      flash[:success] = t "user_report_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_back fallback_location: user_reports_path
  end

  private
  def report_params
    params.require(:user_report).permit UserReport::USER_REPORT_PARAMS
  end

  def load_course
    @courses = current_user.courses
    return unless @courses.empty?

    flash[:danger] = t ".no_courses"
    redirect_to root_url
  end

  def load_report
    @user_report = UserReport.find_by id: params[:id]
    return if @user_report

    flash[:danger] = t "report_not_found"
    redirect_to user_reports_path
  end
end
