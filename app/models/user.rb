class User < ApplicationRecord
  include PgSearch::Model
  include Codeable

  has_secure_password :password, validations: false

  has_many :short_urls

  validates :name, :email, presence: true
  validates :name, length: { in: 5..50 }
  validates :password, length: { minimum: 6 }, on: :create
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :lockeds, -> { where(locked: true) }
  scope :unlockeds, -> { where(locked: false) }

  def generate_token!
    generate_code!(:token, n = 64)
    self.token
  end

  def generate_access_key!
    generate_code!(:access_key, n = 64)
    self.access_key
  end

  def reset_token!
    self.update(token: nil)
  end

  def locked!
    self.update(locked: true, locked_at: Time.zone.now)
  end

  def unlock!
    self.update(locked: false, locked_at: nil)
  end
end
