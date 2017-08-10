require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:question) { create :question }

    context 'Валидные данные' do
      it 'Новый ответ сохраняется в базе данных' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
            .to change(question.answers, :count).by(1)
      end
      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Не валидные данные' do
      it 'Новый ответ не сохраняется в базе данных' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }
            .to_not change(Answer, :count)
      end
      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
