class CommentsController < ApplicationController
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
    #ログイン前の場合、ログイン画面に遷移
    redirect_to(new_user_session_path) unless user_signed_in?

    @comment = Comment.find(params[:id])
    @user_post_id = @comment.user_post_id

    #エラー時のみメッセージをセットする
    flash[:error] = @comment.errors.full_messages.first unless @comment.destroy
    #コメント画面に戻る
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

    #エラー時のみメッセージをセットする
    flash[:error] = @comment.errors.full_messages.first unless @comment.save
    #コメント画面に戻る
    redirect_back(fallback_location: "comments/#{@user_post_id}/new")
  end
end
