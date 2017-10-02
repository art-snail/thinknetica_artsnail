require_relative 'acceptance_helper'

feature 'Sphinx search', %q{
  As a user I want to be able to search for information of interest to me
} do

  let!(:user) { create(:user, email: 'sphinx@email.com') }
  let!(:question) { create :question, title: 'sphinx', body: 'sphinx' }
  let!(:answer) { create(:answer, body: 'sphinx', question: question) }
  let!(:comment) { create(:comment, user: user, body: 'sphinx', commentable: question) }

  ThinkingSphinx::Test.run do
    %w(Question Answer Comment User).each do |object|
      scenario "User finds #{object}" do
        visit root_path

        select object
        fill_in 'Найти:', with: 'sphinx'
        click_on 'Search'
        expect(page).to have_content 'Результат поиска'
        expect(page).to have_content object
      end
    end

    scenario 'User find all objects' do
      visit root_path

      select 'All'
      fill_in 'Найти:', with: 'sphinx'
      click_on 'Search'

      %w(Question Answer Comment User).each do |object|
        expect(page).to have_content object
      end
    end

    %w(Question Answer Comment User All).each do |object|
      scenario "no result #{object}" do
        visit root_path

        select object
        fill_in 'Найти:', with: 'other text'
        click_on 'Search'

        expect(page).to have_content 'Nothing found'
      end
    end
  end
end