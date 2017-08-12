require 'rails_helper'

feature 'Anyone can view the list of questions', %q{
  Anyone can view the list of questions
  to find the question that interests him.
} do

  scenario 'View question list' do
    visit questions_path

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Список вопросов'
  end
end