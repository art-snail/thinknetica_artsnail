require_relative 'acceptance_helper'

feature 'Attachment', %q{
  Guest does not see the link to delete the file
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:attachment) { create(:attachment, attachable_id: question.id, attachable_type: 'Question') }

  scenario 'Guest does not see the link to delete the file' do
    visit question_path(question)
    within '#question' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to_not have_link 'Удалить фаил'
    end
  end
end