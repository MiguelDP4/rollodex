class StaticPagesController < ApplicationController
  def home
    @user = current_user
    @posts = @user.friends.map { |friend| friend.posts }.flatten(1)
    @posts += @user.posts
    @posts = @posts.sort_by { |post| post.created_at }
    @posts = @posts.reverse

    @post = current_user.posts.build if user_signed_in?
  end
end
