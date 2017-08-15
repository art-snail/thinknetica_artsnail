FactoryGirl.define do
  sequence :body do |n|
    "Answer Text-#{n}"
  end

  factory :answer do
    question nil
    body "MyText"
    user
  end

  factory :answer_list, class: 'Answer' do
    body
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
