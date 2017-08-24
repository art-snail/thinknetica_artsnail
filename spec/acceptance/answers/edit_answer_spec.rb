require_relative '../acceptance_helper'

feature 'Answer editing', %{
  In order to correct the error, as the author of the answer, I want to edit my answer.
} do

  let(:user) {create(:user)}
  let!(:question) {create(:question)}
  let!(:answer) {create(:answer, question: question, user: user)}

  scenario 'A nonautocytified user tries to edit the answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Редактировать ответ'
  end

  scenario 'The author tries to edit the answer with valid attributes', js: true do
    sign_in user
    visit question_path(question)

    within '#answers' do
      # pry
      expect(page).to have_link 'Редактировать ответ'
      expect(page).to_not have_selector 'textarea'
    end
    click_link 'Редактировать ответ'

    within '#answers' do
      expect(page).to_not have_link 'Редактировать ответ'
      expect(page).to have_selector 'textarea'
    end

    # wait_for_ajax
    within '#answers' do
      fill_in 'Answer', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'The author tries to edit the answer with invalid attributes', js: true do
    sign_in user
    visit question_path(question)
    click_link 'Редактировать ответ'

    within '#answers' do
      fill_in 'Answer', with: nil
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end
  end

  let(:user_not_author) { create(:user)}
  scenario 'Autocified user tries to edit the answer other user' do
    sign_in user_not_author
    visit question_path(question)

    expect(page).to_not have_link 'Редактировать ответ'
  end
end