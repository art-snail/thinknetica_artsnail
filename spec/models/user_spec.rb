require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  let(:user) { create(:user)}
  let(:question) {create(:question, user: user)}
  let(:other_user) { create(:user) }

  it 'check author_of? for author' do
    expect(user).to be_author_of(question)
  end

  it 'check author_of? for not author' do
    expect(other_user).to_not be_author_of(question)
  end
end
