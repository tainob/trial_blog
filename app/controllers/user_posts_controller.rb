class UserPostsController < ApplicationController

  #TOPページ
  def index
  end

  #自分の投稿一覧ページ
  def mylist
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

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

    #ログイン済の場合、自分の書き込みを除外する
    @user_posts = @user_posts.where.not(user_id: current_user.id) if user_signed_in?

    #ページング処理
    @user_posts = @user_posts.paginate(:page => params[:page], :per_page => 10)
  end

  #登録ページ
  def new
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @user_post = UserPost.new
  end

  #編集ページ
  def edit
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @user_post = UserPost.find(params[:id])
    #ログイン前の場合、ログイン画面に遷移
  end

  #更新
  def update
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @user_post = UserPost.find(params[:id])
    if @user_post.update(
                      title: params[:user_post][:title],
                      image: params[:user_post][:image],
                      content: params[:user_post][:content],
                      category: params[:user_post][:category],
                      invisible: params[:user_post][:invisible])
      redirect_to("/")
    else
      render :edit
    end
  end

  #削除
  def destroy
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @user_post = UserPost.find(params[:id])
    if @user_post.destroy
      redirect_to("/")
    else
      render :edit
    end
  end

  #DB書込み
  def create
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @user_post = UserPost.new(user_post_params)

    @user_post.title = params[:user_post][:title]
    @user_post.image = params[:user_post][:image]
    @user_post.content = params[:user_post][:content]
    @user_post.category = params[:user_post][:category]

    #非表示設定
    if params[:user_post][:invisible].nil?
      @user_post.invisible = false
    else
      @user_post.invisible = params[:user_post][:invisible]
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

  private

    def user_post_params
      params.permit(:title, :image, :content, :category, :invisible, :create_date, :release_date, :user_id)
    end

end
