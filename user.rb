class User < ActiveRecord::Base

  has_many :user_urls, dependent: :destroy
  has_many :urls, through: :user_urls

end