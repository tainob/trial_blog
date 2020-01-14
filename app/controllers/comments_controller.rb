class CommentsController < ApplicationController
  #一覧・登録ページ
  def new
    @comment = Comment.new
    @comments = Comment.where(user_post_id: params[:id])
    @user_post = UserPost.find(params[:id])
  end

  #削除
  def destroy
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @comment = Comment.find(params[:id])
    @user_post_id = @comment.user_post_id   #削除前に親idを退避

    flash[:error] = @comment.errors.full_messages.first unless @comment.destroy
    redirect_back(fallback_location: "comments/#{@user_post_id}/new")
  end

  #DB書込み
  def create
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @comment = Comment.new
    @comment.user_post_id = params[:comment][:user_post_id]
    @comment.content = params[:comment][:content]
    @comment.user = current_user
    @user_post_id = params[:comment][:user_post_id]

    flash[:error] = @comment.errors.full_messages.first unless @comment.save
    redirect_back(fallback_location: "comments/#{@user_post_id}/new")
  end
end
