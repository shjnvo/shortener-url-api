class ShortUrl < ApplicationRecord
  include Codeable

  HOST = 'http://localhost:3000'
  
  belongs_to :user

  validates :url, url: true, presence: true
  validates :code, presence: true

  before_validation :assign_code

  scope :url_for, ->(user) { where(user: user).order(created_at: :desc) }
  scope :top_100_for, ->(user) { where(user: user).where('clicked_count > 0').order(clicked_count: :desc).limit(100) }

  private

  def assign_code
    return if self.code
    generate_code(:code, n = 6)
    self.code
  end
end
