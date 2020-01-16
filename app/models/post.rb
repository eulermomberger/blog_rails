class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags

  validates :title, length: { within: 1..255 }, uniqueness: true
  validates :description, length: { minimum: 10 }

  def index_info
    {
      id: self.id,
      title: self.title,
      description: self.description,
      updated_at: self.updated_at,
      user: self.user,
      comments: self.info,
      tags: self.tags.select(:id, :name),
    }
  end

  def info
    list = []
    self.comments.each do |comment|
      if comment.comment_id == nil
        list.push comment.show
      end
    end
    list
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
