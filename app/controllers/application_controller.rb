class ApplicationController < ActionController::Base
  before_action :set_locale, :load_notification

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{head :forbidden}
      format.html{redirect_to main_app.root_url, alert: exception.message}
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    respond_to do |format|
      format.json{head :forbidden}
      format.html{redirect_to main_app.root_url, alert: exception.message}
    end
  end

  private
  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include? locale
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_supervisor
    return if current_user.admin? || current_user.supervisor?

    flash[:warning] = t "insufficient_privileges"
    redirect_to root_url
  end

  def load_notification
    return unless current_user

    @notifications = current_user.notifications
  end
end
