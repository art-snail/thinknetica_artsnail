FactoryGirl.define do
  factory :comment do
    user nil
    commentable_id 1
    commentable "MyString"
    body "MyText"
  end
end
