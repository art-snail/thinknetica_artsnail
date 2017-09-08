require_relative 'acceptance_helper'

feature 'Comment for question or answer', %q{
  As a user I want to be able to leave comments on questions and answers.
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
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

  describe 'Guest' do
    context 'question' do
      scenario 'try to create comment' do
        visit question_path(question)

        within '#comments' do
          expect(page).to_not have_content 'Ваш комментарий'
        end
      end
    end
  end

  describe 'multiple sessions' do
    context 'question' do
      scenario "comment appears on another user's page", :js do
        Capybara.using_session('user') do
          sign_in user
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within '#comments' do
            fill_in 'Ваш комментарий', with: 'Мой комментарий'
            click_on 'Добавить комментарий'

            expect(page).to have_content 'Мой комментарий'
          end
        end

        Capybara.using_session('guest') do
          within '#comments' do
            expect(page).to have_content 'Мой комментарий'
          end
        end
      end
    end
  end
end