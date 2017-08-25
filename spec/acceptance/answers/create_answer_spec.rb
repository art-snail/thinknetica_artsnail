require_relative '../acceptance_helper'

feature 'Create answer', %q{
  As a registered user, I can respond to questions
  to help solve the problems of users and communicate their knowledge.
} do

  let(:user) { create(:user)}
  let(:question) { create(:question) }

  scenario 'Authenticated user creates a answer with valid attributes', js: true do
    sign_in(user)

    visit question_path question
    fill_in 'Ваш ответ', with: 'Мой ответ'
    click_on 'Ответить'

    expect(current_path).to eq question_path question
    within '#answers' do
      expect(page).to have_content 'Мой ответ'
    end
  end

  scenario 'Authenticated user creates a answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path question
    fill_in 'Ваш ответ', with: nil
    click_on 'Ответить'

    # pry
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'An unauthenticated user creates a answer' do
    visit question_path question
    fill_in 'Ваш ответ', with: 'Мой ответ'
    click_on 'Ответить'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end