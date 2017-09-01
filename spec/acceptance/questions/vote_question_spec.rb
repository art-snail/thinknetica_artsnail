require_relative '../acceptance_helper'

feature 'Voting for question', %q{
  As a user I want to be able to vote for a question
} do
  let(:user) {create(:user)}
  let(:question) {create(:question, user: user)}

  scenario 'authenticated user is author try to vote', :js do
    sign_in user
    visit question_path(question)

    within '#vote' do
      expect(page).to_not have_content 'vote-up'
      expect(page).to_not have_content 'vote-down'
      expect(page).to_not have_content 'vote-delete'
    end
  end

  let(:user_not_author) {create(:user)}
  scenario 'authenticated user non author try to vote-up & remove her vote', :js do
    sign_in user_not_author
    visit question_path(question)

    within '#vote' do
      expect(page).to have_link 'vote-up'
      expect(page).to have_link 'vote-down'
      expect(page).to have_link 'vote-delete'

      vote = find('.result-vote').text.to_i
      click_on 'vote-up'
      # pry
      wait_for_ajax
      expect(find('.result-vote').text.to_i).to eq vote + 1
      click_on 'vote-delete'
      wait_for_ajax
      expect(find('.result-vote').text.to_i).to eq vote
    end
  end

  scenario 'authenticated user non author try to vote-down & remove her vote', :js do
    sign_in user_not_author
    visit question_path(question)

    within '#vote' do
      expect(page).to have_link 'vote-up'
      expect(page).to have_link 'vote-down'
      expect(page).to have_link 'vote-delete'

      vote = find('.result-vote').text.to_i
      click_on 'vote-down'
      wait_for_ajax
      expect(find('.result-vote').text.to_i).to eq vote - 1
      click_on 'vote-delete'
      wait_for_ajax
      expect(find('.result-vote').text.to_i).to eq vote
    end
  end

  scenario 'authenticated user non author try to double vote up or down', :js do
    sign_in user_not_author
    visit question_path(question)

    within '#vote' do
      click_on 'vote-up'
      wait_for_ajax
      click_on 'vote-up'
      expect(page).to have_content 'Вы уже голосовали'
      click_on 'vote-delete'
      wait_for_ajax
      expect(page).to_not have_content 'Вы уже голосовали'
      click_on 'vote-down'
      wait_for_ajax
      click_on 'vote-down'
      wait_for_ajax
      expect(page).to have_content 'Вы уже голосовали'
      click_on 'vote-delete'
      wait_for_ajax
      expect(page).to_not have_content 'Вы уже голосовали'
      click_on 'vote-down'
      wait_for_ajax
      click_on 'vote-up'
      expect(page).to have_content 'Вы уже голосовали'
    end
  end

  scenario 'authenticated user non author tries to remove the voice before they vote', :js do
    sign_in user_not_author
    visit question_path(question)

    within '#vote' do
      click_on 'vote-delete'
      wait_for_ajax
      expect(page).to have_content 'Вы ещё не голосовали'
    end
  end

  scenario 'unauthenticated user try to vote' do
    visit question_path(question)

    within '#vote' do
      expect(page).to_not have_content 'vote-up'
      expect(page).to_not have_content 'vote-down'
      expect(page).to_not have_content 'vote-delete'
    end
  end
end