class CreateUserPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_posts do |t|
      t.text     :title
      t.text     :image
      t.text     :content
      t.string   :category
      t.boolean  :visible, defalut: false
      t.datetime :create_date
      t.datetime :release_date
      t.timestamps
    end
  end
end
