# Quick Start Guide: Universo Platformo Ruby

**Last Updated**: 2025-11-17  
**Version**: 0.1.0 (Initial Setup)

## Overview

This guide will walk you through setting up Universo Platformo Ruby on your local development machine and creating your first cluster with domains and resources.

**Estimated Time**: 15 minutes

---

## Prerequisites

Before starting, ensure you have the following installed:

- **Ruby 3.2.0 or higher**
  ```bash
  ruby --version  # Should show 3.2.0 or higher
  ```

- **Bundler** (Ruby dependency manager)
  ```bash
  gem install bundler
  ```

- **PostgreSQL** (for local development) or **Supabase account** (recommended)
  ```bash
  postgres --version  # For local PostgreSQL
  ```

- **Node.js 16+** (for asset compilation)
  ```bash
  node --version  # Should show v16.0.0 or higher
  ```

- **Git**
  ```bash
  git --version
  ```

---

## Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/teknokomo/universo-platformo-ruby.git

# Navigate to the project directory
cd universo-platformo-ruby

# Verify you're in the right directory
ls -la  # Should see Gemfile, README.md, etc.
```

---

## Step 2: Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies (for Hotwire/Stimulus)
npm install
```

**Expected Output**:
```
Bundle complete! 45 Gemfile dependencies, 102 gems now installed.
```

**Troubleshooting**:
- If `bundle install` fails, check your Ruby version: `ruby --version`
- If PostgreSQL-related errors occur, ensure PostgreSQL development headers are installed:
  - macOS: `brew install postgresql`
  - Ubuntu/Debian: `sudo apt-get install libpq-dev`

---

## Step 3: Configure Environment Variables

### Option A: Using Supabase (Recommended)

1. **Create a Supabase account** at [supabase.com](https://supabase.com)

2. **Create a new project** in the Supabase dashboard

3. **Get your credentials** from Project Settings → API:
   - Project URL
   - `anon` public API key
   - Database connection string (Settings → Database)

4. **Copy the environment template**:
   ```bash
   cp .env.example .env
   ```

5. **Edit `.env` file** with your Supabase credentials:
   ```bash
   # Supabase Configuration
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_KEY=your-anon-public-key
   
   # Database URL (from Supabase Settings → Database)
   DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.your-project.supabase.co:5432/postgres
   
   # Rails Configuration
   RAILS_ENV=development
   RAILS_MAX_THREADS=5
   
   # Secret Key Base (generate with: rails secret)
   SECRET_KEY_BASE=your-generated-secret-key
   ```

6. **Generate a secret key**:
   ```bash
   bundle exec rails secret
   ```
   Copy the output and paste it as `SECRET_KEY_BASE` in `.env`

### Option B: Using Local PostgreSQL

1. **Ensure PostgreSQL is running**:
   ```bash
   # macOS with Homebrew
   brew services start postgresql
   
   # Ubuntu/Debian
   sudo service postgresql start
   ```

2. **Copy the environment template**:
   ```bash
   cp .env.example .env
   ```

3. **Edit `.env` file**:
   ```bash
   DATABASE_URL=postgresql://localhost/universo_platformo_development
   RAILS_ENV=development
   SECRET_KEY_BASE=$(bundle exec rails secret)
   ```

---

## Step 4: Setup the Database

```bash
# Create the database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# (Optional) Seed with sample data
bundle exec rails db:seed
```

**Expected Output**:
```
Created database 'universo_platformo_development'
Created database 'universo_platformo_test'
== 20251117000001 CreateClustersClusters: migrating ==
-- create_table(:clusters_clusters)
   -> 0.0123s
== 20251117000001 CreateClustersClusters: migrated (0.0124s) ==
```

**Troubleshooting**:
- **Connection refused**: Ensure PostgreSQL is running and DATABASE_URL is correct
- **Permission denied**: Check PostgreSQL user permissions
- **Database already exists**: Run `bundle exec rails db:drop` then retry (⚠️ WARNING: This deletes data)

---

## Step 5: Start the Development Server

```bash
# Start Rails server
bundle exec rails server

# Or use the shorthand
bundle exec rails s
```

**Expected Output**:
```
=> Booting Puma
=> Rails 7.0.8 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 6.4.0 (ruby 3.2.0-p0) ("The Eagle of Durango")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 12345
* Listening on http://127.0.0.1:3000
Use Ctrl-C to stop
```

**Open your browser** and navigate to:
```
http://localhost:3000
```

You should see the Universo Platformo welcome page! 🎉

---

## Step 6: Run Tests (Optional but Recommended)

Verify everything is working correctly by running the test suite:

```bash
# Run all tests
bundle exec rspec

# Run with coverage report
COVERAGE=true bundle exec rspec
```

**Expected Output**:
```
Finished in 2.34 seconds (files took 1.23 seconds to load)
45 examples, 0 failures

Coverage report generated for RSpec to /coverage. 127 / 150 LOC (84.67%) covered.
```

---

## Step 7: Create Your First Cluster

Now let's create your first cluster using the Rails console:

```bash
# Open Rails console
bundle exec rails console

# Or use the shorthand
bundle exec rails c
```

In the Rails console:

```ruby
# Create a user (simulating authenticated user)
# In production, this comes from Supabase Auth
user = User.create!(
  email: 'demo@example.com',
  password: 'secure_password_123'
)

# Create a cluster
cluster = user.clusters.create!(
  name: 'My First Cluster',
  description: 'This is my first cluster in Universo Platformo Ruby'
)

puts "✅ Created cluster ##{cluster.id}: #{cluster.name}"

# Create a domain
domain = Clusters::Domain.create!(
  name: 'API Services',
  description: 'Domain for API-related resources'
)

# Add domain to cluster
cluster.domains << domain

puts "✅ Added domain '#{domain.name}' to cluster"

# Create a resource
resource = Clusters::Resource.create!(
  name: 'Users API',
  resource_type: 'rest_api',
  configuration: {
    endpoint: 'https://api.example.com/users',
    method: 'GET',
    timeout: 30
  }
)

# Add resource to domain
domain.resources << resource

puts "✅ Added resource '#{resource.name}' to domain"

# Verify the hierarchy
puts "\n📊 Hierarchy:"
puts "  Cluster: #{cluster.name}"
puts "    └─ Domain: #{domain.name}"
puts "         └─ Resource: #{resource.name}"
puts "              └─ Type: #{resource.resource_type}"
puts "              └─ Endpoint: #{resource.configuration['endpoint']}"

# Exit console
exit
```

**Expected Output**:
```
✅ Created cluster #1: My First Cluster
✅ Added domain 'API Services' to cluster
✅ Added resource 'Users API' to domain

📊 Hierarchy:
  Cluster: My First Cluster
    └─ Domain: API Services
         └─ Resource: Users API
              └─ Type: rest_api
              └─ Endpoint: https://api.example.com/users
```

---

## Step 8: Access via Web Interface

1. **Open your browser** to `http://localhost:3000`

2. **Sign up** or **Log in** (once authentication UI is implemented)

3. **Navigate to Clusters** section

4. **View your cluster** - You should see "My First Cluster" created in Step 7

5. **Explore the interface**:
   - Click on cluster to see domains
   - Click on domain to see resources
   - Try creating new entities via the UI

---

## Step 9: Test the API

You can also interact with the API directly using `curl` or a tool like Postman:

```bash
# Get authentication token (example - actual implementation varies)
TOKEN="your-jwt-token-here"

# List all clusters
curl -X GET http://localhost:3000/api/v1/clusters \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"

# Create a new cluster
curl -X POST http://localhost:3000/api/v1/clusters \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": {
      "name": "API Cluster",
      "description": "Cluster for API testing"
    }
  }'

# Get cluster details
curl -X GET http://localhost:3000/api/v1/clusters/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

**Note**: Authentication implementation details will be finalized as authentication is integrated with Supabase.

---

## Common Commands Reference

### Development

```bash
# Start server
bundle exec rails server

# Start console
bundle exec rails console

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Run security scanner
bundle exec brakeman

# Check for dependency vulnerabilities
bundle exec bundler-audit check --update
```

### Database

```bash
# Create database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Rollback last migration
bundle exec rails db:rollback

# Reset database (⚠️ Deletes all data)
bundle exec rails db:drop db:create db:migrate db:seed

# Seed database
bundle exec rails db:seed

# Check migration status
bundle exec rails db:migrate:status
```

### Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/clusters/cluster_spec.rb

# Run tests with coverage
COVERAGE=true bundle exec rspec

# Run only failed tests
bundle exec rspec --only-failures
```

### Code Quality

```bash
# Run RuboCop (style checker)
bundle exec rubocop

# Auto-fix RuboCop issues
bundle exec rubocop -a

# Run Brakeman (security scanner)
bundle exec brakeman

# Check dependencies for vulnerabilities
bundle exec bundler-audit check --update
```

---

## Troubleshooting

### Port Already in Use

If port 3000 is already in use:

```bash
# Find process using port 3000
lsof -ti:3000

# Kill the process
kill -9 $(lsof -ti:3000)

# Or start on different port
bundle exec rails s -p 3001
```

### Database Connection Errors

```bash
# Verify PostgreSQL is running
pg_isready

# Check database URL
echo $DATABASE_URL

# Test connection manually
psql $DATABASE_URL
```

### Missing Dependencies

```bash
# Clean and reinstall gems
bundle clean --force
bundle install

# Clean and reinstall npm packages
rm -rf node_modules
npm install
```

### Rails Command Not Found

```bash
# Use full bundle exec path
bundle exec rails server

# Or add alias to your shell profile (~/.bashrc or ~/.zshrc)
alias rails='bundle exec rails'
```

---

## Next Steps

Now that you have Universo Platformo Ruby running:

1. **Read the Documentation**:
   - [README.md](../README.md) - Project overview
   - [CONTRIBUTING.md](../CONTRIBUTING.md) - How to contribute
   - [DEVELOPMENT.md](../DEVELOPMENT.md) - Development guide

2. **Explore the Code**:
   - `app/` - Main application code
   - `packages/` - Feature packages (Rails Engines)
   - `spec/` - Test suites

3. **Create More Features**:
   - Add more clusters, domains, and resources
   - Experiment with the API
   - Try creating a new package following the Clusters pattern

4. **Join the Community**:
   - Star the repository on GitHub
   - Report issues or suggest features
   - Submit pull requests

---

## Getting Help

If you encounter issues not covered in this guide:

1. **Check existing documentation**:
   - [README.md](../README.md)
   - [Troubleshooting Guide](../TROUBLESHOOTING.md) (if exists)

2. **Search existing issues**:
   - [GitHub Issues](https://github.com/teknokomo/universo-platformo-ruby/issues)

3. **Create a new issue**:
   - Provide clear description of the problem
   - Include error messages and logs
   - Describe steps to reproduce
   - Mention your environment (OS, Ruby version, etc.)

4. **Ask the community**:
   - Check project discussions
   - Reach out via project communication channels

---

**Quick Start Status**: ✅ COMPLETE  
**Ready for Users**: YES  
**Estimated Setup Time**: 15 minutes
