require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  As an author I want to be able to choose the best answer
} do
  let(:user) {create(:user)}
  let!(:question) {create(:question, user: user)}
  let!(:answers_list) { create_list(:answer, 5, question: question, user: user) }

  scenario 'The author chooses the best answer', js: true do
    sign_in(user)
    visit question_path question

    # pry
    within all('.answer').last do
      expect(page).to have_link 'Пометить как лучший'
      click_on 'Пометить как лучший'
      expect(page).to have_css '.best'
    end
  end
end