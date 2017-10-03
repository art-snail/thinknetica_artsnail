require 'rails_helper'

RSpec.describe Searcher, type: :model do
  context '#search' do
    let!(:user) { create(:user, email: 'sphinx@email.com') }
    let!(:question) { create(:question, title: 'sphinx', body: 'sphinx') }
    let!(:answer) { create(:answer, body: 'sphinx', question: question) }
    let!(:comment) { create(:comment, user: user, body: 'sphinx', commentable: question) }

    %w(question comment answer user all).each do |object|
      context "#{object}" do
        let(:klass) { object == 'all' ? 'ThinkingSphinx' : object }

        it 'calls search' do
          expect(klass.classify.constantize).to receive(:search).with('sphinx', page: 1)
          Searcher.search(object, 'sphinx')
        end
      end
    end

    it 'finds question' do
      allow(Question).to receive(:search).and_return([question])
      expect(Searcher.search('question', 'sphinx')).
          to include({ id: question.id, type: 'Question', title: question.title, body: question.body })
    end

    it 'finds answer' do
      allow(Answer).to receive(:search).and_return([answer])
      expect(Searcher.search('answer', 'sphinx')).
          to include({ id: question.id, type: 'Answer', title: answer.body, body: answer.body })
    end

    it 'finds comment' do
      allow(Comment).to receive(:search).and_return([comment])
      expect(Searcher.search('comment', 'sphinx')).
          to include({ id: question.id, type: 'Comment', title: comment.body, body: comment.body })
    end

    it 'finds user' do
      allow(User).to receive(:search).and_return([user])
      expect(Searcher.search('user', 'sphinx')).
          to include({ id: user.id, type: 'User', title: user.email, body: user.email })
    end

    it 'finds all objects' do
      allow(ThinkingSphinx).to receive(:search).and_return([user, question, answer, comment])
      expect(Searcher.search('all', 'sphinx')).
          to include({ id: question.id, type: 'Question', title: question.title, body: question.body })
      expect(Searcher.search('all', 'sphinx')).
          to include({ id: question.id, type: 'Answer', title: answer.body, body: answer.body })
      expect(Searcher.search('all', 'sphinx')).
          to include({ id: question.id, type: 'Comment', title: comment.body, body: comment.body })
      expect(Searcher.search('all', 'sphinx')).
          to include({ id: user.id, type: 'User', title: user.email, body: user.email })
    end
  end
end
