module StaticPagesHelper
  def goto_login
    redirect_to 'users/sign_in'
  end
end
