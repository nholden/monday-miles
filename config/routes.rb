Rails.application.routes.draw do

  scope module: 'strava' do
    get '/auth/strava/callback', to: 'sessions#create'
  end

  resource :session, only: [:destroy]

end
