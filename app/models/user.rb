class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates :name, length: { within: 1..20 }, uniqueness: true
  validates :email, length: { within: 10..100}, uniqueness: true
end
