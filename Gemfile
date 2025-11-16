source 'https://rubygems.org'

ruby '3.2.3'

# Core Rails framework
gem 'rails', '~> 7.1.2'

# Database - PostgreSQL for Supabase compatibility
gem 'pg', '~> 1.5'

# Supabase integration
gem 'supabase', '~> 0.3'

# Authentication
gem 'devise', '~> 4.9'

# Server
gem 'puma', '~> 6.4'

# Asset pipeline
gem 'sprockets-rails', '~> 3.4'
gem 'importmap-rails', '~> 2.0'
gem 'turbo-rails', '~> 2.0'
gem 'stimulus-rails', '~> 1.3'

# UI Components and Styling
gem 'view_component', '~> 3.9'
gem 'tailwindcss-rails', '~> 2.3'

# Background jobs
gem 'sidekiq', '~> 7.2'

# Pagination
gem 'kaminari', '~> 1.2'

# JSON API
gem 'jbuilder', '~> 2.11'

# Environment variables
gem 'dotenv-rails', '~> 2.8'

# Internationalization
gem 'rails-i18n', '~> 7.0'

# Code quality and security
gem 'rubocop', '~> 1.60', require: false
gem 'rubocop-rails', '~> 2.23', require: false
gem 'rubocop-rspec', '~> 2.26', require: false
gem 'brakeman', '~> 6.1', require: false
gem 'bundler-audit', '~> 0.9', require: false

group :development, :test do
  # Debugging
  gem 'debug', '~> 1.9'
  
  # Testing framework
  gem 'rspec-rails', '~> 6.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.2'
end

group :development do
  # Development server
  gem 'web-console', '~> 4.2'
  
  # Performance
  gem 'rack-mini-profiler', '~> 3.3'
  
  # Linting
  gem 'annotate', '~> 3.2'
end

group :test do
  # Testing utilities
  gem 'capybara', '~> 3.39'
  gem 'selenium-webdriver', '~> 4.16'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.1'
  
  # Code coverage
  gem 'simplecov', '~> 0.22', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.17', require: false
