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
      let(:answer_path) { '0/answers/0/' }

      before {get '/api/v1/questions', params: {format: :json, access_token: access_token.token}}

      it_behaves_like 'API successfully'
      it_behaves_like 'data-returnable'
      it_behaves_like 'questionable'

      it 'question object contains short_title' do
        expect(response.body).
            to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        it_behaves_like 'answerable'
      end
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
      before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}

      it_behaves_like 'API successfully'
      it_behaves_like 'questionable'

      it 'question object contains short_title' do
        expect(response.body).
            to be_json_eql(question.title.truncate(10).to_json).at_path('short_title')
      end

      context 'answers' do
        let(:answer_path) { 'answers/0/' }
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('answers')
        end

        it_behaves_like 'answerable'
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id user_id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
                to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        it "contains file_url" do
          expect(response.body).
              to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions", params: {
                                 question: attributes_for(:question),
                                 access_token: access_token.token,
                                 format: :json
                             } }
        let(:question) { Question.last }
        let(:question_path) { '' }

        it 'return status 201' do
          request
          expect(response.status).to eq 201
        end

        it 'creates new question' do
          expect { request }.to change(Question, :count).by(1)
        end

        it 'sets a current_user to the new question' do
          request
          expect(response.body).to be_json_eql(access_token.resource_owner_id).at_path("user_id")
        end

        context 'attr' do
          before { request }
          it_behaves_like 'questionable'
        end
      end

      context 'with invalid attributes' do
        let(:model) { Question }
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
