# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do

  scope module: 'strava' do
    get '/auth/strava', to: redirect(Strava::AuthRequest::URL), as: :strava_auth_request
    get '/auth/strava/callback', to: 'sessions#create', as: :strava_auth_callback
  end

  namespace :strava do
    resource :webhook_callbacks, only: [:create, :show]
  end

  resource :session, only: [:destroy]

  resources :user, only: [], path: '/u', param: :slug do
    resource :profile, only: [:show], path: '/'
    resource :monday_activities, only: [:show]
  end

  # Sidekiq UI with HTTP Basic authentication
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?

  mount Sidekiq::Web, at: "/sidekiq"

end
