class Url < ActiveRecord::Base
  validate :original, :shortened, presence: true
end