Rails.application.routes.draw do
  #constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        # Users
        post :users, to: 'users#create'
        put :users, to: 'users#update'
        delete :users, to: 'users#destroy'

        # Sessions
        post :sessions, to: 'sessions#create'
        delete :sessions, to: 'sessions#destroy'

        # Items
        resources :items

        # Bookings
        resources :bookings, except: [:index]
        put 'bookings/:id/return', to: 'bookings#return'

        # Categories
        resources :categories

        # Slack Bot
        post :slack, to: 'slack#parse'
      end
    end
  #end
end
