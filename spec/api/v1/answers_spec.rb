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

      before { get "/api/v1/questions/#{question.id}/answers",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'data-returnable'
      it_behaves_like 'answerable'

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/comments')
        end

        %w(id user_id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
                to be_json_eql(comment.send(attr.to_sym).to_json).at_path("0/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/attachments')
        end

        it "contains file_url" do
          expect(response.body).
              to be_json_eql(attachment.file.url.to_json).at_path("0/attachments/0/file/url")
        end
      end
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

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'answerable'

      context 'comments' do
        it 'included in answer object' do
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
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/file/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) { post "/api/v1/questions/#{question.id}/answers",
                             params: { answer: attributes_for(:answer),
                                       access_token: access_token.token,
                                       format: :json } }

        it 'return status 201' do
          request
          expect(response.status).to eq 201
        end

        it 'creates new answer' do
          expect { request }.to change(Answer, :count).by(1)
        end

        it 'sets a current_user to the new answer' do
          request
          expect(response.body).to be_json_eql(access_token.resource_owner_id).at_path("user_id")
        end

        context 'attr' do
          let(:answer) { Answer.last }
          let(:answer_path) { '' }

          before { request }

          it_behaves_like 'answerable'
        end
      end

      context 'with invalid attributes' do
        let(:model) { Answer }
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
