# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch 'set_best', on: :member
    end
  end
  delete '/attachment/:id', to: 'attachments#destroy', as: :attachment_destroy
end
