require_relative 'acceptance_helper'

feature 'Show questions', %q{
  Any user can view the question list to select the one that interests him.
} do

  let!(:questions) { create_list(:question_list, 5) }

  scenario 'show questions' do
    visit questions_path

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Список вопросов'
    questions.each_with_index do |_question, index|
      expect(page).to have_content "Question string-#{index + 1}"
    end
  end
end