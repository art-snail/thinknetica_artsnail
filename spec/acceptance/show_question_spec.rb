require 'rails_helper'

feature 'View a list of questions', %q{
  Anyone can view the list of questions
  to find the question that interests him.
} do

  let(:question) { create(:question) }

  scenario 'View question list' do
    visit question_path question

    expect(current_path).to eq question_path question
    expect(page).to have_content "Вопрос: #{question.title}"
  end
end