class AddUsernameAndPasswordDigestToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
    end
  end
end
