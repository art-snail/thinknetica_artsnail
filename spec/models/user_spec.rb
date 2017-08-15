require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  it 'check author_of?' do
    user = User.new(email: 'test@test.te', password: '12345678')
    question = Question.new(user: user, title: 'question', body: 'text')

    expect(user.author_of?(question.user.id)).to eq true
  end
end
