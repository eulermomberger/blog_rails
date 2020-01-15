class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional:true

  belongs_to :comment, class_name: 'Comment', optional:true
  has_many :comments

  validates :text, presence: true

  def show
    {
      id: self.id,
      text: self.text,
      user: self.user,
      comments: self.list
    }
  end

  def list
    list = []
    comments_children = Comment.all().where(comment_id: self.id)
    comments_children.each do |comment|
      comment = comment.show
      list.push comment
    end
    list
  end

  def self.list_all
    Comment.preload(:comments).all().map do |comment|
      comment.show
    end
  end

  default_scope -> {all.order('updated_at desc')}

end
