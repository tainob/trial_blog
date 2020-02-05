class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:new]

  #一覧・登録ページ
  def new
    @comment = Comment.new
    @comments = Comment.where(user_post_id: params[:id])
    #ページング処理
    @comments = @comments.paginate(:page => params[:page], :per_page => 10)

    @user_post = UserPost.find(params[:id])
  end

  #削除
  def destroy
    @comment = Comment.find(params[:id])
    @user_post_id = @comment.user_post_id

    #エラー時のみメッセージをセットする
    flash[:error] = @comment.errors.full_messages.first unless @comment.destroy
    #コメント画面に戻る
    redirect_back(fallback_location: "comments/#{@user_post_id}/new")
  end

  #DB書込み
  def create
    @comment = Comment.new
    @comment.user_post_id = params[:comment][:user_post_id]
    @comment.content = params[:comment][:content]
    @comment.user = current_user
    @user_post_id = params[:comment][:user_post_id]

    #エラー時のみメッセージをセットする
    flash[:error] = @comment.errors.full_messages.first unless @comment.save
    #コメント画面に戻る
    redirect_back(fallback_location: "comments/#{@user_post_id}/new")
  end
end
