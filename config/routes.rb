Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'tops#index'
  resources :tops, only: [:new]
  resources :fixed_costs, except: [:show]
  resources :categories
  resources :relationships, only: [:create, :destroy]
  resources :notifications, only: [:index] do
    collection do
      delete 'destroy_all'
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    post 'users/guest_admin_sign_in', to: 'users/sessions#guest_admin_sign_in'
  end

  resources :users, only: %i[show edit update] do
    resources :comments
    member do
      get 'mypage'
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
