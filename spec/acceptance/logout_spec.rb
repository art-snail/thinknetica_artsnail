require 'rails_helper'

feature 'User logout', %q{
  The user can exit to quit
} do

  let(:user) { create(:user)}

  scenario 'Registered user try to sign in' do
    sign_in(user)

    click_on 'Выйти'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end