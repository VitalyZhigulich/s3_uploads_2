Rails.application.routes.draw do
  resources :uploads, except: %i[show delete]

  root to: 'uploads#index'
end
