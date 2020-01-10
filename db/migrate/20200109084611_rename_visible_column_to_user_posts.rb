class RenameVisibleColumnToUserPosts < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_posts, :visible, :invisible
  end
end
