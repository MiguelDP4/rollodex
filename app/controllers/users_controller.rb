class UsersController < ApplicationController
  def index
    @pagy, @users = pagy(User.all) if User.all.count != 0
  end

  def search
    @pagy, @users = pagy(User.where('lower(username) like ?', "%#{params[:search_term].downcase}%").or(User.where('lower(email) like ?', "%#{params[:search_term].downcase}%")))
    flash.now[:primary] = "Showing results for \"#{params[:search_term]}\""
  end

  def show
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.posts) if @user.posts.count != 0
  end

  def friends
    @pagy, @users = pagy(current_user.friends)
  end

  def friend_requests
    @pagy, @users = pagy(current_user.friend_requests)
  end
end
