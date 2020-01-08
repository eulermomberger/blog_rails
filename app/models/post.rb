class Post < ApplicationRecord
  validates :title, length: { within: 1..255 }, uniqueness: true
  validates :description, length: { minimum: 10 }
end
