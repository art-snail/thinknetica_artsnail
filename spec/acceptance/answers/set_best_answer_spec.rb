require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  As an author I want to be able to choose the best answer
} do
  let(:user) {create(:user)}
  let!(:question) {create(:question, user: user)}
  let!(:answers_list) { create_list(:answer, 5, question: question, user: user) }
  # let!(:answer) { creat}
  let (:other_user) {create(:user)}

  scenario 'The author chooses the best answer', js: true do
    sign_in(user)
    visit question_path question

    # pry
    within all('.answer').last do
      expect(page).to have_link 'Пометить как лучший'
      click_on 'Пометить как лучший'
    end
    within '#answers' do
      expect(page).to have_css '.best'
      expect(page).to have_content 'Ответ успешно помечен лучшим.'
    end
  end

  scenario 'The not author chooses the best answer', js: true do
    sign_in(other_user)
    visit question_path question

    within '#answers' do
      answers_list.each do
        expect(page).to_not have_link 'Пометить как лучший'
      end
    end
  end

  scenario 'An unauthenticated user chooses the best answer', js: true do
    visit question_path question

    within '#answers' do
      answers_list.each do
        expect(page).to_not have_link 'Пометить как лучший'
      end
    end
  end
end