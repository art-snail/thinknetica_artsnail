FactoryGirl.define do
  factory :vote do
    user nil
    votable_id 1
    votable_type "MyString"
    option 1
  end
end
