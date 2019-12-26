class AddUserIdToUserPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :user_posts, :user_id, :integer
  end
end
