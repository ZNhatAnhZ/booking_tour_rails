class TourRequest < ApplicationRecord
  enum status: {pending: 0, approved: 1, rejected: 2}
  after_create :subtract_stock
  around_update :modify_stock
  after_destroy :add_stock

  belongs_to :user
  belongs_to :tour

  delegate :image, :avg_rating, :name, :price, :stock, :end_date, :start_date,
           to: :tour, prefix: true

  UPDATABLE_ATTRS = %i(user_id tour_id quantity total_price).freeze

  validates :status, presence: true
  validates :quantity, :total_price, presence: true,
                                     numericality: {
                                       greater_than_or_equal_to:
                                        Settings.tour.quantity_min
                                     }

  scope :most_recent, ->{order(created_at: :asc)}
  scope :lastest, ->{order(created_at: :desc)}

  def position
    TourRequest.most_recent.index(self) + 1
  end

  def next
    TourRequest.where("created_at > ?",
                      created_at).most_recent.first
  end

  private

  def subtract_stock
    tour.update! stock: (tour.stock - quantity)
  end

  def modify_stock
    new_stock = tour.stock + quantity_was
    yield
    tour.update! stock: (new_stock - quantity)
  end

  def add_stock
    tour.update! stock: (tour.stock + quantity)
  end
end
