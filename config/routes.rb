Rails.application.routes.draw do

  resources :sessions, only: [:new]

  scope module: 'strava' do
    get '/auth/strava/callback', to: 'sessions#create'
  end

end
