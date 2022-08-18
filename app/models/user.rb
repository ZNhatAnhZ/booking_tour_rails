class User < ApplicationRecord
  enum role: {admin: 0, user: 1}

  before_save :downcase_email

  has_many :reviews, dependent: :destroy
  has_many :tour_requests, dependent: :destroy

  UPDATABLE_ATTRS = %i(name email password password_confirmation).freeze

  validates :activated, presence: true
  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  validates :email, presence: true, length: {maximum: Settings.user.email_max},
                    format: {with: Settings.user.email_regex},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                       length: {minimum: Settings.user.pass_min},
                       allow_nil: true
  has_secure_password

  scope :lastest, ->{order(created_at: :desc)}

  private
  def downcase_email
    email.downcase!
  end
end
