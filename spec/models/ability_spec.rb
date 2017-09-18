require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all}

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, create(:question, user: other) }
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, create(:question, user: other) }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, question: question, user: other), user: user }
      it { should be_able_to :destroy, create(:answer, question: question, user: user), user: user }
      it { should_not be_able_to :destroy, create(:answer, question: question, user: other), user: user }
      it { should be_able_to :set_best, create(:answer, question: question), user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update,
                             create(:comment, body: 'new comment', commentable: question, user: user), user: user }
      it { should_not be_able_to :update,
                                 create(:comment,
                                        body: 'new comment',
                                        commentable: question, user: other), user: user }
      it { should be_able_to :destroy,
                             create(:comment, body: 'new comment', commentable: question, user: user), user: user }
      it { should_not be_able_to :destroy,
                                 create(:comment,
                                        body: 'new comment',
                                        commentable: question, user: other), user: user }
    end

    context 'Attachment' do
      let(:file) { Rails.root.join("spec/spec_helper.rb").open }
      let(:other_question) { create(:question, user: other) }

      it { should be_able_to :create, Attachment }
      it { should be_able_to :destroy, create(:attachment, attachable: question, file: file), user: user }
      it { should_not be_able_to :destroy,
                                 create(:attachment, attachable: other_question, file: file), user: user }
    end

    context 'Votable' do
      it { should be_able_to :vote_up, create(:question, user: other), user: user }
      it { should_not be_able_to :vote_up, create(:question, user: user), user: user }

      it { should be_able_to :vote_down, create(:question, user: other), user: user }
      it { should_not be_able_to :vote_down, create(:question, user: user), user: user }

      it { should be_able_to :vote_destroy, create(:question, user: other), user: user }
      it { should_not be_able_to :vote_destroy, create(:question, user: user), user: user }
    end
  end
end