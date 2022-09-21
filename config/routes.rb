Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index', only: [:index]
  # É possível escolher quais routes serão criadas
  # resources :manufacturers, only: [:index, :show, :new]
  resources :manufacturers, only: %i[new create edit update destroy]
  resources :subsidiaries
  resources :car_categories, only: %i[index new create edit update destroy]
  resources :car_models, only: %i[new create edit update destroy]
  resources :clients, only: %i[new index create edit update destroy]
  resources :cars
  resources :car_rentals, only: :show

  resources :rentals, only: %i[index show new create destroy] do
    get 'search', on: :collection
    get 'book', on: :member
    post 'book', on: :member, to: 'rentals#create_book'
    get 'cancel', on: :member
    post 'cancel', on: :member, to: 'rentals#cancellation_confirmation'
  end

  namespace :api do
    namespace :v1 do
      resources :cars, only: %i[index show create update]
      resources :rentals, only: %i[create show]
      resources :clients, only: [] do
        get 'rentals', on: :member, to: 'rentals#client_rentals'
      end
    end
  end
end
