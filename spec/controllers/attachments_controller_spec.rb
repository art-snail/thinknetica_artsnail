require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question, user: @user) }
    let!(:attach) { create(:attachment, attachable_id: question.id, attachable_type: 'Question') }
    let(:request) { delete :destroy, params: { id: attach, format: :js } }
    let(:model) { Attachment }

    describe 'Question' do
      context'The author removes the file attached to the question' do
        it_behaves_like 'destroyable'
      end

      context 'Not the author removes the file attached to the question' do
        sign_in_other_user
        it_behaves_like 'non-changeable'
      end
    end
  end
end
