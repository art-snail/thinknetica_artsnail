require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'renders list of users' do
        items = JSON.parse(response.body)
        expect(items[0]['id']).to eq users[0].id
        expect(items[1]['id']).to eq users[1].id
      end

      it 'does not render authenticated user' do
        JSON.parse(response.body).each do |item|
          expect(item['id']).to_not eq me.id
        end
      end

      %w(id email admin created_at updated_at).each do |attr|
        it "contains #{attr}" do
          items = JSON.parse(response.body)
          expect(items[0]["#{attr}"].to_json).to eq users[0].send(attr.to_sym).to_json
          expect(items[1]["#{attr}"].to_json).to eq users[1].send(attr.to_sym).to_json
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          JSON.parse(response.body).each do |item|
            expect(item["#{attr}"]).to eq nil
          end
        end
      end
    end
  end
end