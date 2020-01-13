class Tag < ApplicationRecord
  has_and_belongs_to_many :posts

  validates :name, presence: true, uniqueness: true, length: {maximum: 20}

  def index_info
    {
      id: self.id,
      name: self.name
    }
  end

  def self.list
    Tag.all().map do |tag|
      tag.index_info
    end
  end
end
