require 'test_helper'

class UserPostsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers


  #トップページ(ログイン前)
  test "should get home" do
    get root_url
    assert_response :success
    assert_template 'user_posts/index'
    assert_select "a[href=?]", new_user_post_url
    assert_select "a[href=?]", mylist_path(category: "日記"), 0
    assert_select "a[href=?]", list_path(category: "日記")
  end

  #トップページ(ログイン後)
  test "should get home with login" do
    log_in( users( :one ) )
    get root_url
    assert_response :success
    assert_template 'user_posts/index'
    assert_select "a[href=?]", new_user_post_url
    assert_select "a[href=?]", mylist_path(category: "日記")
    assert_select "a[href=?]", list_path(category: "日記")
  end

  #新規投稿ページ(ログイン前)
  test "should get post new" do
    get new_user_post_url
    assert_response :found
  end

  #新規投稿ページ(ログイン後)
  test "should get post new with login" do
    log_in( users( :one ) )
    get new_user_post_url
    assert_response :success
    assert_template 'user_posts/new'
  end

  #修正ページ(ログイン前)
  test "should get post edit" do
    @id = user_posts( :post_one ).id
    get "/user_posts/#{@id}/edit"
    assert_response :found
  end

  #修正ページ(ログイン後)
  test "should get post edit with login" do
    @id = user_posts( :post_one ).id
    log_in( users( :one ) )
    get "/user_posts/#{@id}/edit"
    assert_response :success
    assert_template 'user_posts/edit'
  end

  #自己ブログ一覧(ログイン前)
  test "should get mylist" do
    @category = URI.encode("日記")
    get "/mylist?category=#{@category}"
    assert_response :found
  end

  #自己ブログ一覧(ログイン後)
  test "should get mylist with login" do
    @category = URI.encode("日記")
    log_in( users( :one ) )
    get "/mylist?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/mylist'
  end

  #他者ブログ一覧(ログイン前)
  test "should get list" do
    @category = URI.encode("日記")
    get "/list?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/list'
  end

  #他者ブログ一覧(ログイン後)
  test "should get list with login" do
    @category = URI.encode("日記")
    log_in( users( :one ) )
    get "/list?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/list'
  end


  #投稿成功
  test "should save post" do
    log_in( users( :one ) )

    #投稿
    @user_post = UserPost.new(
        title: "テストタイトル",
        content: "テスト記事",
        category: "動物",
        invisible: 0,
        create_date: DateTime.now,
        release_date: DateTime.now,
        user_id: users( :one ).id)
    assert @user_post.save

    #コメント
    @comment = Comment.new(
        content: "テストコメント",
        user_post_id: @user_post.id,
        user_id: users( :one ).id)
    assert @comment.save
  end

end
