require 'rails_helper'

feature 'Create question', %q{
  In order to get a question from the community
  as an authenticated user, I want to be able to ask questions
} do
  let(:user) { create(:user)}

  scenario 'Authenticated user creates a question with valid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully'
    expect(page).to have_content 'test question'
    expect(page).to have_content 'text text'
    end

  scenario 'Authenticated user creates a question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'An unauthenticated user creates a question' do
    visit questions_path
    click_on 'Ask question'

    # save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end