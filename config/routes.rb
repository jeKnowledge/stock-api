Rails.application.routes.draw do
  #constraints subdomain: 'api' do
  scope module: 'api' do
    namespace :v1 do
      # Users
      post :users, to: 'users#create'
      #put :users, to: 'users#update'
      #delete :users, to: 'users#destroy'

      # Sessions
      post :sessions, to: 'sessions#create'
      put :sessions, to: 'sessions#update'
      delete :sessions, to: 'sessions#destroy'

      # Items
      resources :items, only: [:index, :create]

      # Bookings
      resources :bookings, only: [:create]
      put 'bookings/:id/return', to: 'bookings#return'

      # Waiting Queue
      resources :waiting_queues, only: [:create]

      # Categories
      #resources :categories

      # Slack Bot
      post :slack, to: 'slack#parse'
    end
  end
  #end
end
