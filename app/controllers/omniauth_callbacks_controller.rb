class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    authenticate('Facebook') if @user.persisted?
  end

  def twitter
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    oauth_with_email(@user, auth, 'Twitter')
  end

  private

  def oauth_with_email(user, auth, kind)
    if user.persisted?
      authenticate(kind)
    else
      email = "#{DateTime.now.to_i}-#{rand(999)}@qnamail.com"
      user = create_user_and_auth(email, auth)
      render 'mail_form', locals: { user: user }, layout: false
    end
  end

  def authenticate(kind)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end
end
