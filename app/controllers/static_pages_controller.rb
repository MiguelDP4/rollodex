class StaticPagesController < ApplicationController
  def home
    @user = current_user
    
      # @pagy, @posts = pagy(@posts.reverse)
    @pagy, @posts = pagy(Post.all.where(user_id: (@user.friends.pluck :id)).or(Post.all.where(user_id: (@user.id))))
    @post = current_user.posts.build if user_signed_in?
  end
end
