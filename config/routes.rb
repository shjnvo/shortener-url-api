Rails.application.routes.draw do
  get '/:code', to: 'v1/short_urls#visited_link'

  namespace :v1 do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :users, except: :index do
      member do
        patch :lock
        patch :unlock
      end
    end
    resources :short_urls, except: :show do
      get :top_100, on: :collection
    end
  end
end
