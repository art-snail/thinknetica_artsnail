require 'rails_helper'

describe 'Answer API' do
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment,
                                 attachable: answer,
                                 file: Rails.root.join("spec/spec_helper.rb").open) }
      let(:answer_path) { '0/' }
      let(:comment_path) { '0/comments' }
      let(:attachment_path) { '0/attachments' }

      before { get "/api/v1/questions/#{question.id}/answers",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'data-returnable'
      it_behaves_like 'answerable'
      it_behaves_like 'comments-included'
      it_behaves_like 'attachments-included'
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question) }
    let(:user) { create(:user) }
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachment) { create(:attachment,
                               attachable: answer,
                               file: Rails.root.join("spec/spec_helper.rb").open) }
    let(:answer_path) { '' }
    let(:comment_path) { 'comments' }
    let(:attachment_path) { 'attachments' }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'answerable'
      it_behaves_like 'comments-included'
      it_behaves_like 'attachments-included'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:model) { Answer }

      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers",
                             params: { answer: attributes_for(:answer),
                                       access_token: access_token.token,
                                       format: :json } }

        it_behaves_like 'API creatable'

        context 'attr' do
          let(:answer) { Answer.last }
          let(:answer_path) { '' }

          before { request }

          it_behaves_like 'answerable'
        end
      end

      context 'with invalid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers",
                             params: { answer: attributes_for(:invalid_answer),
                                       access_token: access_token.token,
                                       format: :json } }

        it_behaves_like 'non-creatable'
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
