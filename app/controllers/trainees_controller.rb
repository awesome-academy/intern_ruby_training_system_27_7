class TraineesController < ApplicationController
  before_action :authenticate_user!
  before_action :logged_in_supervisor
  before_action :load_trainee, only: %i(edit update destroy)

  def index
    @trainees = User.trainee.page(params[:page])
                    .per Settings.course_index_page
  end

  def new
    @trainee = User.new
  end

  def create
    @trainee = User.new trainee_params
    if @trainee.save
      flash[:success] = t ".created_successfully"
      redirect_to trainees_path
    else
      flash.now[:danger] = t ".created_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @trainee.update trainee_params
      flash[:success] = t ".updated_successfully"
      redirect_to trainees_path
    else
      flash.now[:danger] = t ".updated_failed"
      render :edit
    end
  end

  def destroy
    if @trainee.destroy
      flash[:success] = t ".destroy_successfully"
    else
      flash[:danger] = t ".destroy_failed"
    end
    redirect_to trainees_path
  end

  private
  def trainee_params
    params.require(:user).permit User::TRAINEE_PARAMS
  end

  def load_trainee
    @trainee = User.trainee.includes(User::USER_INCLUDES)
                   .find_by id: params[:id]
    return if @trainee

    flash[:danger] = t "not_found"
    redirect_to trainees_path
  end
end
