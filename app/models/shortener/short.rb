# Shortener::Short is the short link for some (long) URL
class Shortener::Short < ApplicationRecord
  validates :token, :original_url, :expire_at, presence: true
  validates :token, uniqueness: true, length: { is: 6 }, if: -> { self.token.present? }

  def expired? = expire_at <= Date.current
end
