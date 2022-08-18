class TourRequestsController < ApplicationController
  before_action :logged_in_user, :current_user_activated?,
                only: %i(index create update destroy)
  before_action :find_tour_requests, only: %i(update destroy)
  before_action :find_tour, only: %i(create update destroy)
  before_action :load_tour_requests, only: :index

  def index; end

  def create
    tour_request =
      TourRequest.create tour_requests_params.merge(user_id: current_user.id)

    if tour_request.persisted?
      find_tour
      tour_request_success
      broadcast_message current_user, tour_request
    else
      tour_request_failed tour_request
    end
  end

  def update
    tour_request_pos = @tour_request.position
    if @tour_request.update tour_requests_params
      load_tour_requests_jump tour_request_pos, 0
      tour_request_updated
    else
      @tour_request.reload
      tour_request_update_failed
    end
  end

  def destroy
    tour_request_pos = @tour_request.position
    jump_page = get_jump_page tour_request_pos
    if @tour_request.destroy
      load_tour_requests_jump tour_request_pos, jump_page
      tour_request_destroyed
    else
      tour_request_destroy_failed
    end
  end

  private

  def tour_requests_params
    params.require(:tour_request).permit TourRequest::UPDATABLE_ATTRS
  end

  def find_tour
    @tour = @tour_request&.tour ||
            Tour.find_by(id: tour_requests_params[:tour_id])

    return if @tour

    flash[:danger] = t ".can_not_find_tour"
    redirect_to root_path
  end

  def find_tour_requests
    @tour_request = current_user.tour_requests.find_by id: params[:id]
    return if @tour_request

    respond_to do |format|
      if format.js
        flash.now[:danger] = t "tour_request_invalid"
        render status: :ok
      end
    end
  end

  def tour_request_success
    respond_to do |format|
      format.js{flash.now[:success] = t(".tour_request_success")}
    end
  end

  def tour_request_failed tour_request
    respond_to do |format|
      format.js do
        message = tour_request.errors.full_messages.to_sentence
        flash.now[:danger] =
          message.presence || t(".tour_request_error")
      end
    end
  end

  def tour_request_updated
    respond_to do |format|
      format.js{flash.now[:success] = t ".tour_request_updated"}
    end
  end

  def tour_request_update_failed
    respond_to do |format|
      format.js{flash.now[:danger] = t ".update_failed"}
    end
  end

  def tour_request_destroyed
    respond_to do |format|
      format.js{flash.now[:success] = t ".tour_request_cancelled"}
    end
  end

  def tour_request_destroy_failed
    respond_to do |format|
      format.js{flash.now[:danger] = t ".cancel_failed"}
    end
  end

  def load_tour_requests
    @pagy, @tour_requests = pagy current_user.tour_requests.most_recent,
                                 items: Settings.tours_request.per_page_user,
                                 link_extra: 'data-remote="true"'
  end

  def load_tour_requests_jump tour_request_pos, jump_page
    page = (tour_request_pos.to_f / Settings.tours_request.per_page_user).ceil -
           jump_page
    @pagy, @tour_requests = pagy current_user.tour_requests.most_recent,
                                 items: Settings.tours_request.per_page_user,
                                 link_extra: 'data-remote="true"',
                                 page: page
  end

  def get_jump_page tour_request_pos
    tour_request_per_page = Settings.tours_request.per_page_user
    page_condition = tour_request_pos != 1 &&
                     tour_request_pos % tour_request_per_page == 1 &&
                     !@tour_request.next

    page_condition ? 1 : 0
  end

  def broadcast_message current_user, tour_request
    ActionCable.server.broadcast "notifications_channel",
                                 {tour: @tour,
                                  user_name: tour_request.user_name,
                                  quantity: tour_request.quantity,
                                  user_id: current_user.id}
  end
end
