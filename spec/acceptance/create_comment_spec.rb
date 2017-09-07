require_relative 'acceptance_helper'

feature 'Comment for question or answer', %q{
  As a user I want to be able to leave comments on questions and answers.
} do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'User' do
    before do
      sign_in user
      visit question_path(question)
    end
    context 'creates comment for question' do
      scenario 'with valid attributes', :js do
        within '#comments' do
          fill_in 'Ваш комментарий', with: 'Мой комментарий'
          click_on 'Добавить комментарий'
          expect(page).to have_content 'Комментарий успешно добавлен.'
          expect(page).to have_content 'Мой комментарий'
        end
      end

      scenario 'with invalid attributes', js: true do
        within '#comments' do
          click_on 'Добавить комментарий'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end
end