Rails.application.routes.draw do
  root "top#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  devise_scope :user do
    resources :users, only: %i[show index]
  end

  resources :reactions, only: %i[create]
  resources :matching, only: %i[index]
  resources :chat_rooms, only: %i[create show]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
