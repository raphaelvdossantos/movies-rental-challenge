Rails.application.routes.draw do
  root "movies#index"

  resources :movies, only: [:index, :show] do
    get :recommendations, on: :collection
    get :user_rented_movies, on: :collection
    get :rent, on: :member
  end
end
