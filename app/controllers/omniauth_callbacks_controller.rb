class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    authenticate('Facebook') if @user.persisted?
  end

  def twitter
    oauth_with_email('Twitter')
  end

  private

  def oauth_with_email(kind)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
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
