class BlogsController < ApplicationController

  def index
    @user_posts = UserPost.all
  end

  def create
    @user_post = UserPost.new(blog_params)
    @user_post.user = current_user

    if @user_post.save

    else
      render :action => "new"
    end
  end

  private

    def blog_params
      params.permit(:title, :image, :content, :category, :visible, :create_date, :release_date, :user_id)
    end

end
