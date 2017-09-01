FactoryGirl.define do
  # factory :vote do
  #   user nil
  #   votable_id 1
  #   votable_type "MyString"
  #   option 1
  # end

  factory :vote, class: 'Vote' do
    self.votable { |a| a.association :resource }
    user

    trait :up do
      option 1
    end

    trait :down do
      option -1
    end
  end
end
