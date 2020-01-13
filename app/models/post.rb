class Post < ApplicationRecord
  has_many :comments
  has_and_belongs_to_many :tags

  validates :title, length: { within: 1..255 }, uniqueness: true
  validates :description, length: { minimum: 10 }

  def index_info
    {
      id: self.id,
      title: self.title,
      description: self.description,
      comments: self.comments,
      tags: self.tags
    }
  end

  def show
    {
      id: self.id,
      title: self.title,
      description: self.description,
      comments: self.comments.select(:id, :text, :created_at),
      tags: self.tags.select(:id, :name)
    }
  end

  def check_tag(tag)
    raise ActiveRecord::RecordNotUnique if self.tags.include?(tag)
  end

  def self.list
    Post.preload(:comments).all().map do |post|
      post.index_info
    end
  end

end
