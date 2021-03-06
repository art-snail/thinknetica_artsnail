require_relative '../acceptance_helper'

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

    expect(page).to have_content 'Your question was successfully created.'
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

    expect(page).to_not have_content 'Ask question'
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", :js do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'test question'
        fill_in 'Body', with: 'text text'
        click_on 'Create'

        expect(page).to have_content 'test question'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test question'
      end
    end
  end
end