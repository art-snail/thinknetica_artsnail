require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:model) { Question }

  it_behaves_like 'voting' do
    let(:model) { create(:question) }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    let(:action) { 'index' }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it_behaves_like 'render-templatable'
  end

  describe 'GET #show' do
    let(:action) { 'show' }

    before { get :show, params: { id: question } }

    it 'Sets the requested question to a variable' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it_behaves_like 'render-templatable'
  end

  describe 'GET #new' do
    let(:action) { 'new' }
    sign_in_user

    before { get :new }

    it 'sets the requested question to a variable question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it_behaves_like 'render-templatable'
  end

  describe 'GET #edit' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let(:action) { 'edit' }

    before { get :edit, params: { id: question } }

    it 'sets the requested question to a variable' do
      expect(assigns(:question)).to eq question
    end

    it_behaves_like 'render-templatable'
  end

  describe 'POST #create' do
    sign_in_user

    let(:request) { post :create, params: { question: attributes_for(:question) } }

    context 'with valid attributes' do
      it_behaves_like 'creatable'

      it 'redirects to show view' do
        request
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:request) { post :create, params: { question: attributes_for(:invalid_question) } }
      let(:action) { 'new' }

      it_behaves_like 'non-changeable'
      it_behaves_like 'render-templatable'
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: @user) }
    let(:request) { patch :update,
                          params: { id: question, question: attributes_for(:question), format: :js } }
    let(:action) { 'update' }

    sign_in_user

    context 'with valid attributes' do
      it 'sets the requested question to a variable' do
        request
        expect(assigns(:question)).to eq question
      end

      it 'data is changing' do
        patch :update,
              params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it_behaves_like 'render-templatable'
    end

    context 'with invalid attributes' do
      before { patch :update,
                     params: { id: question, question: { title: 'new title', body: nil }, format: :js } }
      it 'data does not change' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
      it_behaves_like 'render-templatable'
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, user: @user) }
    let(:request) { delete :destroy, params: { id: question } }
    let(:model) { Question }

    context 'The author removes the question' do
      it_behaves_like 'destroyable'

      it 'redirect index view' do
        request
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not the author tries to remove the question' do
      sign_in_other_user

      it_behaves_like 'non-changeable'

      it 'redirect show view' do
        request
        expect(response).to redirect_to root_path
      end
    end
  end
end
