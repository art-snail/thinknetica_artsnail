require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    let(:request) { post :create,
                        params: { comment: attributes_for(:comment),
                                 user: @user,
                                 question_id: question,
                                 commentable: 'question',
                                 format: :js } }
    let(:action) { :create }

    context 'valid data' do
      let(:model) { question.comments }
      
      it_behaves_like 'creatable'
      it_behaves_like 'render-templatable'
    end

    context 'invalid data' do
      let(:request) { post :create, params: { comment: attributes_for(:invalid_comment),
                                            user: @user,
                                            question_id: question,
                                            commentable: 'question',
                                            format: :js } }
      let(:model) { Comment }

      it_behaves_like 'non-changeable'
      it_behaves_like 'render-templatable'
    end
  end
end
