class User < ApplicationRecord
  has_secure_password
  has_many :posts
  has_many :comments

  validates :name, length: { within: 1..20 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
