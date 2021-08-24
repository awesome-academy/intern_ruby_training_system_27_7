class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user
  before_action :correct_user, only: %i(edit update)

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".updated_successfully"
      redirect_to user_path
    else
      flash.now[:danger] = t ".updated_failed"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def correct_user
    return if @user == current_user

    flash[:warning] = t "incorrect_user"
    redirect_to root_path
  end
end
