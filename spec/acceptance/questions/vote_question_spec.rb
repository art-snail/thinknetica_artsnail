require_relative '../acceptance_helper'

feature 'Voting for question', %q{
  As a user I want to be able to vote for a question
} do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'authenticated user is author try to vote', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'vote-up'
    expect(page).to_not have_content 'vote-down'
    expect(page).to_not have_content 'vote-delete'
  end

  let(:user_not_author) { create(:user)}
  scenario 'authenticated user non author try to vote', js: true do
    sign_in user_not_author
    visit question_path(question)

    expect(page).to have_link 'vote-up'
    expect(page).to have_link 'vote-down'
    expect(page).to have_link 'vote-delete'

    it 'vote-up' do
      vote = find('.result-vote').text.to_i
      click_on 'vote-up'
      expect(find('result-vote').text.to_i).to eq vote + 1
    end
    it 'down'
  end

  scenario 'unauthenticated user try to vote' do
    visit question_path(question)

    expect(page).to_not have_content 'vote-up'
    expect(page).to_not have_content 'vote-down'
    expect(page).to_not have_content 'vote-delete'
  end
end