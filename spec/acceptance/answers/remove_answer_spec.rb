require_relative '../acceptance_helper'

feature 'Remove answer', %q{
  The author can remove his answer
} do
  let(:user) { create(:user)}
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:user_not_author) { create(:user)}

  scenario 'The author removes the answer', js: true do
    sign_in(user)

    visit question_path question

    click_on 'Удалить ответ'

    within '#answers' do
      expect(page).to have_content 'Ответ успешно удалён.'
      expect(page).to_not have_content 'MyText'
    end
    expect(current_path).to eq question_path question
  end

  scenario 'An unauthenticated user trying to remove a answer' do
    visit question_path question

    expect(page).to_not have_content 'Удалить ответ'
  end

  scenario 'Autocified user, but not the author tries to remove the question' do
    sign_in(user_not_author)

    visit question_path question

    expect(page).to_not have_content 'Удалить вопрос'
  end
end