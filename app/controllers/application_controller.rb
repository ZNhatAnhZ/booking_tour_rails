class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  add_flash_types :success, :danger, :warning
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".edit_login_danger"
    redirect_to login_path
  end

  def check_admin
    return true if current_user&.admin?

    flash[:danger] = t ".check_admin.permission"
    redirect_to root_path
  end

  def success_format title
    respond_to do |format|
      format.js{flash[:success] = title}
    end
  end

  def danger_format title
    respond_to do |format|
      format.js{flash[:danger] = title}
    end
  end

  def current_user_activated?
    return if current_user.activated?

    store_location
    flash[:danger] = t ".user_not_activated"
    redirect_to root_path
  end
end
