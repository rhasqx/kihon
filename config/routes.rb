Rails.application.routes.draw do
  get 'misc/print'
  resources :tokens
  root 'tokens#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
