require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  Warden.test_mode!

  #トップページ(ログイン前)
  test "should get home without login" do
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
  test "should not get post new without login" do
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
  test "should not get post edit without login" do
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

  #修正ページ(ログイン後 別ユーザ)
  test "should not get post edit with other login" do
    @id = user_posts( :post_one ).id
    log_in( users( :two ) )
    get "/user_posts/#{@id}/edit"
    assert_response :found
  end

  #自己ブログ一覧(ログイン前)
  test "should not get mylist without login" do
    @category = URI.encode("日記")
    get "/mylist?category=#{@category}"
    assert_response :found
  end

  #自己ブログ一覧(ログイン後 投稿1件)
  test "should get mylist with login post1" do
    @category = URI.encode("日記")
    log_in( users( :one ) )
    get "/mylist?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/mylist'
    @id = user_posts( :post_one ).id
    assert_select "a[href=?]", "/user_posts/#{@id}/edit" #「編集する」リンク検証
    assert_select "a[href=?]", "/comments/#{@id}/new"    #「コメントを見る」リンク検証
  end

  #自己ブログ一覧(ログイン後 投稿していないユーザ)
  test "should get mylist with login post0" do
    @category = URI.encode("日記")
    log_in( users( :two ) )
    get "/mylist?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/mylist'
  end

  #自己ブログ一覧(ログイン後 ページングあり)
  test "should get mylist with login paging" do
    @category = URI.encode("旅行")
    log_in( users( :one ) )
    get "/mylist?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/mylist'
    assert_select "a[href=?]", "/mylist?category=#{@category}&page=2", 2
  end

  #他者ブログ一覧(ログイン前)
  test "should get list without login" do
    @category = URI.encode("日記")
    get "/list?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/list'
  end

  #他者ブログ一覧(ログイン後)
  test "should get list with login" do
    @category = URI.encode("旅行")
    log_in( users( :one ) )
    get "/list?category=#{@category}"
    assert_response :success
    assert_template 'user_posts/list'
  end

end
