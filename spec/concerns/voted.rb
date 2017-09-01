require 'rails_helper'

shared_examples_for 'voting' do
  describe 'PATCH #vote_up' do
    sign_in_user
    context 'Not the author tries to vote in the top' do
      context 'the user has already voted' do
        before { create(:vote, :up, user: @user, votable: model) }

        it 'dont change votes' do
          expect{ patch :vote_up, params: { id: model } }.to_not change(model.votes, :count)
        end

        it 'render error' do
          patch :vote_up, params: { id: model }
          expect(response.body).to eq 'Вы уже голосовали'
        end

        it 'response status 422' do
          patch :vote_up, params: { id: model }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user did not vote' do
        it 'create a new vote' do
          expect{ patch :vote_up, params: { id:model } }.to change(model.votes, :result).by(1)
        end
      end
    end

    context 'Author try to vote up' do
      before { model.update(user: @user) }

      it 'dont change votes' do
        expect{ patch :vote_up, params: { id:model } }.to_not change(model.votes, :result)
      end

      it 'response status 422' do
        patch :vote_up, params: { id:model }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    context 'Not the author tries to vote in the bottom' do
      context 'the user has already voted' do
        before { create(:vote, :down, user: @user, votable: model) }

        it 'dont change votes' do
          expect{ patch :vote_down, params: { id: model } }.to_not change(model.votes, :result)
        end

        it 'render error' do
          patch :vote_down, params: { id: model }
          expect(response.body).to eq 'Вы уже голосовали'
        end

        it 'response status 422' do
          patch :vote_down, params: { id: model }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user did not vote' do
        it 'create a new vote' do
          expect{ patch :vote_down, params: { id: model } }.to change(model.votes, :result).by(-1)
        end
      end
    end

    context 'author try to vote down' do
      before { model.update(user: @user) }

      it 'dont change votes' do
        expect{ patch :vote_down, params: { id: model } }.to_not change(model.votes, :result)
      end

      it 'response status 422' do
        patch :vote_down, params: { id: model }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #vote_destroy' do
    sign_in_user
    context 'the user has already voted' do
      before {create(:vote, :down, user: @user, votable: model)}

      it 'change votes count' do
        expect { delete :vote_destroy, params: { id: model } }.to change(model.votes, :count).by(-1)
      end
    end

    context 'user did not vote' do
      it 'votes dont change' do
        expect { delete :vote_destroy, params: { id: model } }.to_not change(model.votes, :count)
      end
    end
  end
end