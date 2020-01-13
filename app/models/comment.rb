class Comment < ApplicationRecord
  belongs_to :post

  validates :text, presence: true

  default_scope -> {all.order('updated_at desc')}

end
