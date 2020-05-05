class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Your post was published."
      redirect_to request.referrer
    else
      flash[:danger] = "Something went wrong. Try again later."
      redirect_to request.referrer
    end
  end
  private

  def post_params
    params.require(:post).permit(:content)
  end
  def logged_in_user
    unless user_signed_in?
      flash[:danger] = "Log in first to be able to post."
      redirect_to login_url
    end
  end
end
