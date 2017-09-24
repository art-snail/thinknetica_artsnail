require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) {create :question}
  let(:model) { Answer }

  it_behaves_like 'voting' do
    let(:model) { create(:answer, question: question) }
  end

  describe 'POST #create' do
    sign_in_user
    let(:request) { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }
    let(:action) { :create }
    let(:model) { question.answers }

    context 'valid data' do
      it_behaves_like 'creatable'
      it_behaves_like 'render-templatable'

      it 'assigns answer with current user' do
        request
        assigning_answer = assigns(:answer)
        expect(assigning_answer.user_id).to eq subject.current_user.id
      end
    end

    context 'not valid data' do
      let(:request) { post :create,
                           params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }

      it_behaves_like 'non-changeable'
      it_behaves_like 'render-templatable'
    end
  end

  describe 'PATH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:request) { patch :update,
                          params: { id: answer,
                                   question_id: question, answer: attributes_for(:answer), format: :js } }
    let(:action) { :update }

    it 'assigns the requested answer to @answer' do
      request
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update,
            params: {id: answer, question_id: question, answer: { body: 'new body'}, format: :js}

      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it_behaves_like 'render-templatable'
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user: @user) }
    let(:request) { delete :destroy, params: { question_id: question, id: answer, format: :js } }
    let(:action) { :destroy }

    context 'The author removes the answer' do
      it_behaves_like 'destroyable'
      it_behaves_like 'render-templatable'
    end

    context 'Not the author tries to remove the answer' do
      sign_in_other_user
      it_behaves_like 'non-changeable'
      it_behaves_like 'response-403'
    end
  end

  describe 'PATH #set_best' do
    sign_in_user
    let!(:question2) { create :question, user: @user }
    let!(:answer) { create(:answer, question: question2) }
    let(:request) { patch :set_best, params: { id: answer, format: :js } }
    let(:action) { :set_best }

    context 'Authenticated user in author' do
      it 'The author chooses the best answer' do
        request
        answer.reload
        expect(answer.best).to eq true
      end

      it_behaves_like 'render-templatable'
    end

    context 'Authenticated user is not author' do
      sign_in_other_user

      it 'Not the author of the question tries to choose the best answer' do
        request
        answer.reload
        expect(answer.best).to eq false
      end

      it_behaves_like 'response-403'
    end
  end
end
