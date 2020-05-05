class StaticPagesController < ApplicationController
  def home
    @user = current_user
    @posts = @user.friends.map { |friend| friend.posts }.flatten(1)
  end
end
