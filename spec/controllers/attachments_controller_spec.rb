require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let(:attach) { create(:attachment, attachable_id: question.id, attachable_type: 'Question') }

    describe 'Question' do
      context'The author removes the file attached to the question' do
        it 'user eq author' do
          attach
          expect { delete :destroy, params: { id: attach, format: :js } }.to change(Attachment, :count).by(-1)
        end
      end

      context 'Not the author removes the file attached to the question' do
        sign_in_other_user
        it 'user not_eq author' do
          attach
          expect { delete :destroy, params: { id: attach, format: :js } }.to_not change(Attachment, :count)
        end
      end
    end
  end
end
