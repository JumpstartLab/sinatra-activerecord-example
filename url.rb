class Url < ActiveRecord::Base
  validate :original, :shortened, presence: true

  has_many :user_urls, dependent: :destroy
end