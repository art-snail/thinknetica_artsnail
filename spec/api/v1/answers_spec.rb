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

      before { get "/api/v1/questions/#{question.id}/answers",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

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

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}",
                   params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

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
        it 'return status 201' do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:answer),
                         access_token: access_token.token,
                         format: :json }

          expect(response.status).to eq 201
        end

        it 'creates new answer' do
          expect { post "/api/v1/questions/#{question.id}/answers",
                        params: { answer: attributes_for(:answer),
                                  access_token: access_token.token,
                                  format: :json } }.
              to change(Answer, :count).by(1)
        end

        it 'sets a current_user to the new answer' do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:answer),
                         access_token: access_token.token,
                         format: :json }

          expect(response.body).to be_json_eql(access_token.resource_owner_id).at_path("user_id")
        end

        context 'attr' do
          before { post "/api/v1/questions/#{question.id}/answers",
                        params: { answer: attributes_for(:answer),
                                  access_token: access_token.token,
                                  format: :json } }

          %w(id body user_id created_at updated_at).each do |attr|
            it "answer object contains #{attr}" do
              expect(response.body).to be_json_eql(Answer.last.send(attr.to_sym).to_json).at_path("#{attr}")
            end
          end
        end
      end

      context 'with invalid attributes' do
        it 'returns status 422' do
          post "/api/v1/questions/#{question.id}/answers",
               params: { answer: attributes_for(:invalid_answer),
                         access_token: access_token.token,
                         format: :json }

          expect(response.status).to eq 422
        end

        it 'does not create new answer' do
          expect { post "/api/v1/questions/#{question.id}/answers",
                        params: { answer: attributes_for(:invalid_answer),
                                  access_token: access_token.token,
                                  format: :json } }.
              to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
