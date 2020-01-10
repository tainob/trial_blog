class CommentsController < ApplicationController
  #一覧・登録ページ
  def new
    @comment = Comment.new
    @comments = Comment.where(user_post_id: params[:id])
    @user_post = UserPost.find(params[:id])
  end

  #削除
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to("/")
  end

  #DB書込み
  def create
    @comment = Comment.new
    @comment.user_post_id = params[:comment][:user_post_id]
    @comment.content = params[:comment][:content]
    @comment.user = current_user

    if @comment.save
      redirect_to("/")
    else
      render :action => "new"
    end
  end
end
