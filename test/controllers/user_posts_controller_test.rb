require 'test_helper'

class UserPostsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  Warden.test_mode!

  #投稿失敗(未入力)
  test "should not save post without title" do
    @user_post1 = UserPost.new
    assert_not @user_post1.save
  end

  #投稿成功
  test "should save post" do
    @user_post = UserPost.new(
        title: "テストタイトル",
        content: "テスト記事",
        category: "その他",
        invisible: 0,
        create_date: DateTime.now,
        release_date: DateTime.now,
        user_id: users( :one ).id)
    assert @user_post.save
  end

end
