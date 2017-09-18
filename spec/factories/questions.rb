# frozen_string_literal: true

FactoryGirl.define do
  sequence :title do |n|
    "Question string-#{n}"
  end

  factory :question do
    title 'MyString'
    body 'MyText'
    user
  end

  factory :question_list, class: 'Question' do
    title
    body 'MyText'
    user
    end

  factory :question_new, class: 'Question' do
    title 'new title'
    body 'new body'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
