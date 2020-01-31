class AddNumberOfPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :number_of_posts, :integer, :default => 0
  end
end
