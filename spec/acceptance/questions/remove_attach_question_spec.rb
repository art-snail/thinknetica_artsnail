require_relative '../acceptance_helper'

feature 'Removing a file from a question', %q{
  As an author I want to be able to remove files attached to a question
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attach) { create(:attachment, attachable_id: question.id, attachable_type: 'Question') }


  scenario 'author can remove attach', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_content 'spec_helper.rb'
    # pry

    within '#question' do
      click_on 'Удалить фаил'
      expect(page).to_not have_content 'spec_helper.rb'
    end
  end

  let(:user_not_author) { create(:user)}
  scenario "non author can't remove", js: true do
    sign_in user_not_author
    visit question_path(question)
    within '#question' do
      expect(page).to_not have_link 'Удалить фаил'
    end
  end
end