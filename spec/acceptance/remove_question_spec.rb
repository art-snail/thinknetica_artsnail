require 'rails_helper'

feature 'Remove question', %q{
  The author can remove his question
} do
  let(:user) { create(:user)}
  let(:question) { create(:question, user: user) }
  let(:user_not_author) { create(:user)}

  scenario 'The author removes the question' do
    sign_in(user)

    visit question_path question
    click_on 'Удалить вопрос'

    expect(page).to have_content 'Вопрос успешно удалён.'
    expect(current_path).to eq questions_path
  end

  scenario 'An unauthenticated user trying to remove a question' do
    visit question_path question

    expect(page).to_not have_content 'Удалить вопрос'
  end

  scenario 'Autocified user, but not the author tries to remove the question' do
    sign_in(user_not_author)

    visit question_path question

    expect(page).to_not have_content 'Удалить вопрос'
  end
end