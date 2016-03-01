Rails.application.routes.draw do
  namespace :backend do
    resources :events, :badges
    resources :teams, :only => [:index, :show, :edit, :update, :destroy]
    resources :users, :only => [:index, :show, :edit, :update, :destroy]
    resources :scores, :only => [:update]
  end

  resources :teams
  resources :events, :only => [:index, :show]
  resources :badges, :only => [:index, :show]
  devise_for :users, controllers: { registrations: "users/registrations" }
  
  post '/join/team', to: 'teams#join'
  get '/leave/team/:id', to: 'teams#leave', as: 'leave_team'
  post '/join/event', to: 'events#join'
  #get '/leave/event/:id', to: 'events#leave', as: 'leave_event'

  get '/profile/:id', to: 'pages#profile', as: 'profile'
  get '/store', to: 'pages#store', as: 'store'
  get '/hire', to: 'pages#hire', as: 'hire'
  get '/changelog', to: 'pages#changelog', as: 'changelog'

  get '/backend/update_scores', to: 'backend/teams#update_scores', as: 'backend_update_scores'
  post '/backend/adjust_score', to: 'backend/scores#adjust_score', as: 'backend_adjust_score'

  get 'contact', to: 'pages#hire', as: 'contact'
  post 'contact', to: 'contacts#create'

  get 'speed', to: 'speed#index', as: 'speed'
  
  root to: "pages#index"
end
