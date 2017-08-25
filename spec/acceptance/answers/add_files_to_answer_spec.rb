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

  scenario 'User adds file to answer' do
    fill_in 'Ваш ответ', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Отвеить'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end