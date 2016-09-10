source 'https://rubygems.org'

ruby "2.3.1"

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Server
gem 'puma', '~> 3.0'

# Database
gem 'pg'

gem 'active_model_serializers', '~> 0.10.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

gem 'bcrypt', '~> 3.1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'rack-attack'

group :development, :test do
  gem 'byebug', platform: :mri

  gem 'rspec-rails', '3.1.0'
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen', '~> 3.0.5'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
