# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

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
end
