require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe 'The value is set that the answer is the best' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer_list, 5, question: question) }

    it 'Set the best answer' do
      answer = answers.first
      answer.set_best
      expect(answer.best?).to eq true
    end

    it 'There can only be one best answer' do
      answers.each do |answer|
        answer.set_best
      end
      expect(question.answers.best.count).to eq 1
    end
  end

  it_behaves_like 'votable' do
    let(:question) { create(:question) }
    let(:model) { create(:answer, question: question) }
    let(:model2) { create(:answer, question: question) }
  end
end
