require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) {create :question}

  describe 'POST #create' do
    sign_in_user

    context 'valid data' do
      it 'a new answer is stored in the database' do
        expect {post :create,
                     params: {answer: attributes_for(:answer), question_id: question, format: :js}}
            .to change(question.answers, :count).by(1)
      end
      it 'assigns answer with current user' do
        post :create, params: {answer: attributes_for(:answer), question_id: question, format: :js}
        assigning_answer = assigns(:answer)
        expect(assigning_answer.user_id).to eq subject.current_user.id
      end
      it 'render create template' do
        post :create, params: {answer: attributes_for(:answer), question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end

    context 'not valid data' do
      it 'the new answer is not stored in the database' do
        expect {post :create,
                     params: {answer: attributes_for(:invalid_answer), question_id: question, format: :js}}
            .to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, params: {answer: attributes_for(:invalid_answer), question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATH #update' do
    sign_in_user

    let(:answer) { create(:answer, question: question)}

    it 'assigns the requested answer to @answer' do
      patch :update,
            params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}

      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update,
            params: {id: answer, question_id: question, answer: { body: 'new body'}, format: :js}

      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update,
            params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}

      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) {create(:answer, question: question, user: @user)}

    context 'The author removes the answer' do
      it 'the answer is deleted' do
        answer
        expect {delete :destroy, params: {question_id: question, id: answer, format: :js}}
            .to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: {question_id: question, id: answer, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'Not the author tries to remove the answer' do
      sign_in_other_user
      it 'the answer not remove' do
        answer
        expect {delete :destroy, params: {question_id: question, id: answer, format: :js}}
            .to_not change(Answer, :count)
      end

      it 'redirect show question' do
        delete :destroy, params: {question_id: question, id: answer, format: :js}
        expect(response).to render_template :destroy
      end
    end
  end
end
