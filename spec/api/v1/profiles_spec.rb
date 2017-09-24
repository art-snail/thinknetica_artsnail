require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:profile_path) { '' }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'profilable'
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user) { users.first }
      let(:profile_path) { '0/' }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API successfully'
      it_behaves_like 'data-returnable'
      it_behaves_like 'profilable'

      it 'does not render authenticated user' do
        JSON.parse(response.body).each do |item|
          expect(item['id']).to_not eq me.id
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end