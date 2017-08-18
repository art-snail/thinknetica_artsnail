require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let(:question) {create :question}

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

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) {create(:question)}
    let!(:answer) {create(:answer, question: question, user: @user)}

    context 'The author removes the answer' do
      it 'the answer is deleted' do
        answer
        expect {delete :destroy, params: {question_id: question, id: answer}}
            .to change(Answer, :count).by(-1)
      end

      it 'redirect show question' do
        delete :destroy, params: {question_id: question, id: answer}
        expect(response).to redirect_to question
      end
    end

    context 'Not the author tries to remove the answer' do
      sign_in_other_user
      it 'the answer not remove' do
        answer
        expect {delete :destroy, params: {question_id: question, id: answer}}
            .to_not change(Answer, :count)
      end

      it 'redirect show question' do
        delete :destroy, params: {question_id: question, id: answer}
        expect(response).to redirect_to question
      end
    end
  end
end
