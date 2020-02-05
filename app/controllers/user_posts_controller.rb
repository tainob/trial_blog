class UserPostsController < ApplicationController

  #TOPページ
  def index
  end

  #自分の投稿一覧ページ
  def mylist
    @category = params[:category]
    @user_posts = UserPost.order(create_date: :DESC)
                    .where(category: @category)
                    .where(user_id: current_user.id)

    #ページング処理
    @user_posts = @user_posts.paginate(:page => params[:page], :per_page => 10)
  end

  #他ユーザ投稿一覧ページ
  def list
    @category = params[:category]

    @user_posts = UserPost.order(create_date: :DESC)
                  .where('release_date <= ?', DateTime.now)
                  .where(invisible: false)
                  .where(category: @category)

    #ページング処理
    @user_posts = @user_posts.paginate(:page => params[:page], :per_page => 10)
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
    if @user_post.update(user_post_params)
      redirect_to("/")
    else
      render :edit
    end
  end

  #削除
  def destroy
    @user_post = UserPost.find(params[:id])
    if @user_post.destroy
      redirect_to("/")
    else
      render :edit
    end
  end

  #新規投稿
  def create
    @user_post = UserPost.new(user_post_params)
    @user_post.user = current_user

    if @user_post.save

    else
      render :action => "new"
    end
  end

  private

    def user_post_params
      params.require(:user_post).permit(
        :title, :image, :content, :category, :invisible, :create_date, :release_date, :user_id)
    end

end
