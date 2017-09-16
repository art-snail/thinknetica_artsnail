class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      email = "#{DateTime.now.to_i}-#{rand(999)}@qnamail.com"
      password = Devise.friendly_token[0, 20]
      @user = User.create!(email: email, password: password, password_confirmation: password)
      @user.create_authorization(request.env['omniauth.auth'])
      render 'mail_form', locals: { user: @user }, layout: false
    end
  end
end
