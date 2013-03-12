class User < ActiveRecord::Base

  has_many :user_urls
  has_many :urls, through: :user_urls

end