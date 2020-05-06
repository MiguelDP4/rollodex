class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.all) if User.all.count != 0
  end

  def show
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.posts) if @user.posts.count != 0
  end
end
