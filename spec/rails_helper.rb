# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'
require 'shoulda/matchers'
require 'webmock/rspec'

# Detect database availability BEFORE configuring RSpec.
# Set ALLOW_DBLESS_TESTS=true to allow running without a database.
# Without the flag, missing DB will raise immediately.
DB_AVAILABLE = begin
  ActiveRecord::Base.connection.execute('SELECT 1')
  true
rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad => e
  if ENV['ALLOW_DBLESS_TESTS'] == 'true'
    warn '[RSpec] No database connection available. DB-dependent tests will be skipped.'
    false
  else
    raise e
  end
end

# When no DB is available, patch ActiveRecord::TestFixtures to prevent
# any connection attempts during test lifecycle hooks (before_setup, setup_fixtures).
# This allows service/unit tests to run without a database.
unless DB_AVAILABLE
  module NoDatabaseFixturesPatch
    def before_setup; end
    def after_teardown; end
    def setup_fixtures(*); end
    def teardown_fixtures; end
  end
  ActiveRecord::TestFixtures.prepend(NoDatabaseFixturesPatch)
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
if DB_AVAILABLE
  begin
    ActiveRecord::Migration.maintain_test_schema!
  rescue ActiveRecord::PendingMigrationError => e
    abort e.to_s.strip
  end
end

RSpec.configure do |config|
  # Disable ActiveRecord fixture support when no DB is available
  config.use_active_record = DB_AVAILABLE

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  # Use transactional fixtures only when DB is available
  config.use_transactional_fixtures = DB_AVAILABLE

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # FactoryBot configuration
  config.include FactoryBot::Syntax::Methods

  # Database Cleaner configuration (only when DB is available)
  if DB_AVAILABLE
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning { example.run }
    end
  end
end

# Shoulda Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
