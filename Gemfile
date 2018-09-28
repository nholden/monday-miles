source 'https://rubygems.org'
ruby `cat .ruby-version`.chomp

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'haml'
gem 'rollbar'
gem 'high_voltage'
gem 'sidekiq'
gem 'sinatra', '~> 2.0.1'
gem 'excon'
gem 'decent_exposure'
gem 'draper'
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'webpacker', '~> 3.0'
gem 'bootsnap', require: false
gem 'secure_headers'

group :development, :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails_real_favicon'
end

group :test do
  gem 'launchy'
  gem 'rspec-given'
end
