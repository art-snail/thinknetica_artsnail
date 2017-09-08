FactoryGirl.define do
  factory :comment do
    user nil
    body "MyText"
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
