require 'rails_helper'

describe 'Question API' do
  let(:access_token) {create(:access_token)}

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let(:question_path) { '0/' }
      let(:answer_path) { '0/answers' }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'data-returnable'
      it_behaves_like 'questionable'

      it 'question object contains short_title' do
        expect(response.body).
            to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      it_behaves_like 'answers-included'
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:user) {create(:user)}
    let(:question) {create(:question)}
    let!(:answer) {create(:answer, question: question)}
    let!(:comment) {create(:comment, commentable: question, user: user)}
    let!(:attachment) {create(:attachment,
                              attachable: question,
                              file: Rails.root.join("spec/spec_helper.rb").open)}

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:question_path) { '' }
      let(:answer_path) { 'answers' }
      let(:comment_path) { 'comments' }
      let(:attachment_path) { 'attachments' }

      before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}

      it_behaves_like 'API successfully'
      it_behaves_like 'questionable'
      it_behaves_like 'answers-included'
      it_behaves_like 'comments-included'
      it_behaves_like 'attachments-included'

      it 'question object contains short_title' do
        expect(response.body).
        to be_json_eql(question.title.truncate(10).to_json).at_path('short_title')
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:model) { Question }

      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions", params: {
                                 question: attributes_for(:question),
                                 access_token: access_token.token,
                                 format: :json
                             } }
        let(:question) { Question.last }
        let(:question_path) { '' }

        it_behaves_like 'API creatable'

        context 'attr' do
          before { request }
          it_behaves_like 'questionable'
        end
      end

      context 'with invalid attributes' do
        let(:request) { post "/api/v1/questions", params: {
            question: attributes_for(:invalid_question),
            access_token: access_token.token,
            format: :json
        } }

        it_behaves_like 'non-creatable'
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end
end
