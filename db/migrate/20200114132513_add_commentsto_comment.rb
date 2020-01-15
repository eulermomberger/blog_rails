class AddCommentstoComment < ActiveRecord::Migration[5.2]
  def change
    change_table :comments do |t|
      t.references :comment, foreign_key: true
    end
  end
end
