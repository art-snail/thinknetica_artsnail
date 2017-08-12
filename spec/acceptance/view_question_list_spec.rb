require 'rails_helper'

feature 'Show question', %q{
  Any user can view the question of interest
  to give an answer or see the answers of other users.
} do

  scenario 'show question' do
    visit question_path

    expect(current_path).to eq question_path
    expect(page).to have_content 'Список вопросов'
  end
end