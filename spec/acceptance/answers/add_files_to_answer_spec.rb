require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Ваш ответ', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ответить'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User can add multiply files to answer', js: true do
    fill_in 'Ваш ответ', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Добавить фаил'
    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Ответить'
    within '#answers' do
      # expect(page).to have_content 'spec_helper.rb'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
      # expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
end