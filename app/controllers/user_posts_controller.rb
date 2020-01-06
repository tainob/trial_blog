class UserPostsController < ApplicationController

  #投稿一覧ページ（ログイン後ページ）
  def index
    @user_posts = UserPost.order(create_date: :DESC).where(user_id: current_user.id)
  end

  #登録ページ
  def new
    @user_post = UserPost.new
  end

  #編集ページ
  def edit
    @user_post = UserPost.find(params[:id])
  end

  #更新
  def update
    @user_post = UserPost.find(params[:id])
    @user_post.update(
                      title: params[:user_post][:title],
                      content: params[:user_post][:content],
                      category: params[:user_post][:category],
                      visible: params[:user_post][:visible])
    redirect_to("/")
  end

  #削除
  def destroy
    @user_post = UserPost.find(params[:id])
    @user_post.destroy
    redirect_to("/")
  end

  #DB書込み
  def create
    @user_post = UserPost.new(user_post_params)

    @user_post.title = params[:user_post][:title]
    @user_post.image = params[:user_post][:image]
    @user_post.content = params[:user_post][:content]
    @user_post.category = params[:user_post][:category]

    #非表示設定
    if params[:user_post][:visible] == "0"
      @user_post.visible = false
    else
      @user_post.visible = true
    end if

    @user_post.create_date = DateTime.now

    #公開日
#    if params[:user_post][:release_date].nil?
#      @user_post.release_date = DateTime.now
#    else
#      @user_post.release_date = params[:user_post][:release_date]
#    end if

    @user_post.user = current_user

    if @user_post.save

    else
      render :action => "new"
    end
  end

  #他ユーザ投稿一覧ページ
  def list
    @category = params[:category]
    @user_posts = UserPost.order(create_date: :DESC)
                    .where('release_date <= ?', DateTime.now)
                    .where(visible: false)
                    .where(category: @category)
  end

  private

    def user_post_params
      params.permit(:title, :image, :content, :category, :visible, :create_date, :release_date, :user_id)
    end

end
