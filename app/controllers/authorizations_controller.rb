class AuthorizationsController < ApplicationController
  layout "layouts/video_call"
  before_action :find_user, :correct_user, :check_user_activated,
                only: %i(edit update)

  def edit
    @activating_user_id = params[:id]
  end

  def update
    if activate_user(params[:id])
      respond_to do |format|
        format.js{flash.now[:success] = t(".activate_user_successful")}
      end
    else
      respond_to do |format|
        format.js{flash.now[:danger] = t(".activate_user_failed")}
      end
    end
  end

  private

  def correct_user
    return if current_user.admin?

    redirect_to root_path unless current_user?(user)
  end

  def check_user_activated
    return unless user&.activated?

    if current_user.admin?
      flash[:danger] = t(".user_already_activated")
      redirect_to admin_users_path
    else
      redirect_to root_path
    end
  end

  def activate_user user_id
    user = User.find_by(id: user_id)
    return false if current_user.user? || user&.activated?

    user.update_attribute(:activated, true)
  end

  def find_user
    user = User.find_by(id: params[:id])
    return if user

    redirect_to root_path
  end
end
