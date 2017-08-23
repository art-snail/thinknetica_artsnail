require_relative '../acceptance_helper'

feature 'Show answers', %q{
  Any user can view the list of answers to get help on an issue of interest to him.
} do

  let(:question) { create :question }
  let!(:answers) { create_list(:answer_list, 5, question: question) }

  scenario 'show questions' do
    visit question_path question

    within '#answers' do
      answers.each_with_index do |_answer, index|
        expect(page).to have_content "Answer Text-#{index + 1}"
      end
    end
  end
end