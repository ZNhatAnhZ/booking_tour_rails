class ReviewsController < ApplicationController
  before_action :logged_in_user, :current_user_activated?, only: :create

  def create
    @review =
      Review.create reviews_params.merge(user_id: current_user.id)
    return review_error if @review.new_record?

    load_reviews
    review_success
  end

  private

  def reviews_params
    params.require(:review).permit Review::UPDATABLE_ATTRS
  end

  def review_success
    respond_to do |format|
      format.js{flash.now[:success] = t(".review_success")}
    end
  end

  def review_error
    respond_to do |format|
      format.js{flash.now[:danger] = review.errors.full_messages.to_sentence}
    end
  end

  def load_reviews
    @pagy, @reviews = pagy Review.where(tour_id: @review.tour_id).most_recent,
                           items: Settings.review.review_per_page,
                             link_extra: 'data-remote="true"'
  end
end
