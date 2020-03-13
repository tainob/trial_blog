require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  Warden.test_mode!

  #コメント投稿失敗(未入力)
  test "should not save comment without content" do
    @comment = Comment.new
    assert_not @comment.save
  end

  #コメント投稿成功
  test "should save post" do
    @comment = Comment.new(
        content: "テストコメント",
        user_post_id: user_posts( :post_one ).id,
        user_id: users( :one ).id)
    assert @comment.save
  end
end
