module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
    end

  def sign_in_other_user
    before do
      @other_user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @other_user
    end
  end
end