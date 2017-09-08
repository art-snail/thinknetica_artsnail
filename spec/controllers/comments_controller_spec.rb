require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'valid data' do
      context 'question' do
        it 'a new comment is stored in the database' do
          expect { post :create,
                        params: { comment: attributes_for(:comment, commentable: question),
                                  user: @user,
                                  question_id: question,
                                  commentable: 'question',
                                  format: :js } }
              .to change(question.comments, :count).by(1)
        end

        it 'render template' do
          post :create, params: { comment: attributes_for(:comment, commentable: question),
                         user: @user,
                         question_id: question,
                         commentable: 'question',
                         format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'invalid data' do
      context 'question' do
        it 'the new comment is not stored in the database' do
          expect { post :create,
                        params: { comment: attributes_for(:invalid_comment, commentable: question),
                                  user: @user,
                                  question_id: question,
                                  commentable: 'question',
                                  format: :js } }
              .to_not change(Comment, :count)
        end

        it 'render template' do
          post :create, params: { comment: attributes_for(:invalid_comment, commentable: question),
                                  user: @user,
                                  question_id: question,
                                  commentable: 'question',
                                  format: :js }
          expect(response).to render_template :create
        end
      end
    end
  end
end
