require 'rails_helper'

describe 'Question API' do
  let(:access_token) {create(:access_token)}

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:questions) {create_list(:question, 2)}
      let(:question) {questions.first}
      let!(:answer) {create(:answer, question: question)}

      before {get '/api/v1/questions', params: {format: :json, access_token: access_token.token}}

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
                to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
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

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before {get "/api/v1/questions/#{question.id}", params: {format: :json, access_token: access_token.token}}

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('answers')
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
                to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
          end
        end
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
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'return status 201' do
          post "/api/v1/questions",
               params: {
                 question: attributes_for(:question),
                 access_token: access_token.token,
                 format: :json
               }

          expect(response.status).to eq 201
        end

        it 'creates new question' do
          expect { post "/api/v1/questions", params: {
                        question: attributes_for(:question),
                        access_token: access_token.token,
                        format: :json }
          }.to change(Question, :count).by(1)
        end

        it 'sets a current_user to the new question' do
          post "/api/v1/questions", params: {
                                      question: attributes_for(:question),
                                      access_token: access_token.token,
                                      format: :json
                                    }

          expect(response.body).to be_json_eql(access_token.resource_owner_id).at_path("user_id")
        end

        context 'attr' do
          before { post "/api/v1/questions", params: {
              question: attributes_for(:question),
              access_token: access_token.token,
              format: :json }
          }

          %w(id title body user_id created_at updated_at).each do |attr|
            it "question object contains #{attr}" do
              expect(response.body).to be_json_eql(Question.last.send(attr.to_sym).to_json).at_path("#{attr}")
            end
          end
        end
      end

      context 'with invalid attributes' do
        it 'returns status 422' do
          post "/api/v1/questions", params: {
              question: attributes_for(:invalid_question),
              access_token: access_token.token,
              format: :json }

          expect(response.status).to eq 422
        end

        it 'does not create new question' do
          expect { post "/api/v1/questions", params: {
              question: attributes_for(:invalid_question),
              access_token: access_token.token,
              format: :json }
          }.to_not change(Question, :count)
        end
      end
    end
  end
end
