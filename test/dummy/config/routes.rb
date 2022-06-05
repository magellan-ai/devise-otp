# frozen_string_literal: true

Dummy::Application.routes.draw do
  devise_for :users

  resources :posts
  root to: 'posts#index'
end
