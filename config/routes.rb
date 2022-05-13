Rails.application.routes.draw do
  root "top#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
