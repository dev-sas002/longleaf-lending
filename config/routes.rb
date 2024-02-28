Rails.application.routes.draw do
  resources :loan_requests, only: %i[new create]
  root 'loan_requests#new'
end
