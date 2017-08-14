require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let(:question) { create :question }

    context 'valid data' do

      it 'a new answer is stored in the database' do
        expect { post :create, params: { answer: attributes_for(:answer),
                                         question_id: question, } }
            .to change(question.answers, :count).by(1)
      end
      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not valid data' do
      it 'the new answer is not stored in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }
            .to_not change(Answer, :count)
      end
      it 're-renders question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let(:answer) { create(:answer, question: question, user: @user) }

    it 'the answer is deleted' do
      answer
      expect { delete :destroy, params: { question_id: question, id: answer } }
          .to change(Answer, :count).by(-1)
    end

    it 'redirect index show question' do
      delete :destroy, params: { question_id: question, id: answer }
      expect(response).to redirect_to question_path question
    end
  end
end
