require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:net_user) { create(:user) }
  let!(:authorization) { create(:authorization, user: net_user) }

  describe 'POST #oauth_email' do
    context 'there is the user with the same email' do
      let!(:user) { create(:user, email: 'user@qnamail.com') }

      it 'assigns the net_user' do
        post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' }
        expect(assigns(:net_user)).to eq net_user
      end

      it 'remove net_user' do
        expect { post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' } }.
            to change(User, :count).by(-1)
      end

      it 'remove net_user.authorization' do
        expect { post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' } }.
            to change(net_user.authorizations, :count).by(-1)
      end

      it 'add authorization for user' do
        expect { post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' } }.
            to change(user.authorizations, :count).by(1)
      end

      it 'sign in user' do
        post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' }
        expect(subject.current_user).to eq user
      end
    end

    context 'there is no user with the same email' do
      before { post :oauth_email, params: { id: net_user, email: 'user@qnamail.com' } }

      it 'assigns the net_user' do
        expect(assigns(:net_user)).to eq net_user
      end

      it 'update email for net_user' do
        net_user.reload
        expect(net_user.email).to eq 'user@qnamail.com'
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
