class UsersController < ApplicationController
  def oauth_email
    @net_user = User.find(params[:id])
    auth = @net_user.authorizations.first
    @user = User.find_by_email(params[:email])
    if @user
      @user.authorizations.create(provider: auth.provider, uid: auth.uid)
      @net_user.destroy
      user = @user
    else
      @net_user.update(email: params[:email])
      user = @net_user
    end
    sign_in_and_redirect user, event: :authentication
    flash[:notice] = 'Вы успешно авторизованы.'
  end
end
