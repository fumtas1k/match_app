Rails.application.routes.draw do
  root "top#index"

  devise_for :users
  resources :users, only: %i[show]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
