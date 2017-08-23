require_relative '../acceptance_helper'

feature 'Question editing', %{
  In order to correct the error, as the author of the question, I want to edit my question.
} do

  let(:user) {create(:user)}
  let!(:question) {create(:question, user: user)}

  scenario 'A nonautocytified user tries to edit the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Редактировать ответ'
  end

  scenario 'The author tries to edit the question', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to have_link 'Редактировать вопрос'

    within '#edit-question' do
      expect(page).to_not have_selector 'textarea'
    end

    click_link 'Редактировать вопрос'

    within '#edit-question' do
      expect(page).to_not have_link 'Редактировать вопрос'
      expect(page).to have_selector 'textarea'

      # pry
      fill_in 'Title', with: 'new title question'
      fill_in 'Body', with: 'new body question'
      click_on 'Edit'

      expect(page).to_not have_selector 'textarea'
    end

    expect(page).to_not have_content question.body
    expect(page).to have_content 'new title question'
    expect(page).to have_content 'new body question'
  end

  let(:user_not_author) { create(:user)}
  scenario 'Autocified user tries to edit the answer other user' do
    sign_in user_not_author
    visit question_path(question)

    expect(page).to_not have_link 'Редактировать вопрос'
  end
end