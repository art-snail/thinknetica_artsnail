# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_destroy
    end
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :comments, defaults: { commentable: 'questions' }
    resources :answers, concerns: [:votable] do
      resources :comments, defaults: { commentable: 'answers' }
      patch 'set_best', on: :member
    end
  end
  delete '/attachment/:id', to: 'attachments#destroy', as: :attachment_destroy

  mount ActionCable.server => '/cable'

  post 'user/:id/oauth_email', to: 'users#oauth_email', as: :oauth_email

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end
end
