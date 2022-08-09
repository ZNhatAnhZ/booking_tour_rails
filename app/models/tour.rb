class Tour < ApplicationRecord
  UPDATABLE_ATTRS = %i(name description price image start_date end_date
avg_rating category_id).freeze

  has_many :tour_requests, dependent: :destroy
  has_many :discounts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :category
  has_many :reviews, dependent: :destroy

  has_one_attached :image

  validates :name, presence: true,
                        length: {maximum: Settings.tour.name_max}
  validates :description, presence: true,
                               length: {maximum: Settings.tour.description_max}
  validates :price, :avg_rating, :start_date, :end_date, :stock, presence: true
  validates :image, content_type: {in: Settings.tour.image_type,
                                   message: :mess},
                    size: {
                      less_than: Settings.tour.image_size.megabytes,
                      message: :size_img
                    }

  scope :incre_order, ->{order(id: :asc)}
  scope :order_rating, ->(rating){where("avg_rating = ?", rating)}
  scope :recent_tours, ->{order(created_at: :desc)}

  def display_image
    image.variant resize_to_limit:
    [
      Settings.tour.height_limit,
      Settings.tour.width_limit
    ]
  end
end
