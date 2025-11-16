# Development Guide

This guide provides detailed instructions for setting up and developing Universo Platformo Ruby.

## Prerequisites

### Required Software

- **Ruby**: 3.2.3 or higher
  - Check version: `ruby --version`
  - Install via [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/)
- **PostgreSQL**: 14 or higher (via Supabase)
- **Bundler**: Latest version
  - Install: `gem install bundler`
- **Node.js**: 18 or higher (for asset compilation)
  - Check version: `node --version`
- **Git**: Latest version

### Optional Software

- **Redis**: For background jobs and ActionCable
- **Docker**: For containerized development

## Initial Setup

### 1. Clone and Navigate

```bash
git clone https://github.com/teknokomo/universo-platformo-ruby.git
cd universo-platformo-ruby
```

### 2. Install Ruby Dependencies

```bash
# Install bundler if not already installed
gem install bundler

# Install project dependencies
bundle install
```

### 3. Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your actual values
# You'll need Supabase credentials from https://supabase.com
```

Required environment variables:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_KEY`: Your Supabase anon/public key
- `DATABASE_URL`: PostgreSQL connection string from Supabase
- `SECRET_KEY_BASE`: Generate with `rails secret`

### 4. Setup Database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Load seed data (optional)
rails db:seed
```

### 5. Start the Application

```bash
# Start Rails server
rails server

# Or use short form
rails s
```

Visit `http://localhost:3000` in your browser.

## Development Workflow

### Creating a New Feature

1. **Create an Issue**
   - Follow guidelines in `.github/instructions/github-issues.md`
   - Include English description with Russian translation in spoiler
   - Apply appropriate labels

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Develop**
   - Write code following Rails conventions
   - Add tests for new functionality
   - Update documentation

4. **Test**
   ```bash
   # Run all tests
   bundle exec rspec
   
   # Run specific test file
   bundle exec rspec spec/models/cluster_spec.rb
   
   # Run with coverage
   COVERAGE=true bundle exec rspec
   ```

5. **Code Quality Checks**
   ```bash
   # Run linter
   bundle exec rubocop
   
   # Auto-fix issues
   bundle exec rubocop -A
   
   # Security check
   bundle exec brakeman
   
   # Dependency audit
   bundle exec bundle-audit check --update
   ```

6. **Commit and Push**
   ```bash
   git add .
   git commit -m "Add feature: description"
   git push origin feature/your-feature-name
   ```

7. **Create Pull Request**
   - Follow guidelines in `.github/instructions/github-pr.md`
   - Include English description with Russian translation
   - Link to related Issue

### Creating a New Package

Packages follow the monorepo structure with `-frt` (frontend) and `-srv` (server) suffixes.

```bash
# Create package structure
mkdir -p packages/feature-name-srv/base
mkdir -p packages/feature-name-frt/base

# Create package README files
touch packages/feature-name-srv/README.md
touch packages/feature-name-srv/README-RU.md
touch packages/feature-name-frt/README.md
touch packages/feature-name-frt/README-RU.md
```

For Rails engines:

```bash
# Generate a new engine
cd packages
rails plugin new feature-name-srv --mountable
cd ..
```

## Testing

### Running Tests

```bash
# All tests
bundle exec rspec

# Specific directory
bundle exec rspec spec/models

# Specific file
bundle exec rspec spec/models/cluster_spec.rb

# Specific test
bundle exec rspec spec/models/cluster_spec.rb:15

# With documentation format
bundle exec rspec --format documentation

# With coverage report
COVERAGE=true bundle exec rspec
```

### Writing Tests

Follow RSpec best practices:

```ruby
# spec/models/cluster_spec.rb
require 'rails_helper'

RSpec.describe Cluster, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:domains).dependent(:destroy) }
  end

  describe '#active?' do
    it 'returns true when cluster is active' do
      cluster = create(:cluster, status: 'active')
      expect(cluster.active?).to be true
    end
  end
end
```

## Code Quality

### RuboCop Configuration

RuboCop is configured in `.rubocop.yml`. Key rules:

- Follow Ruby style guide
- Maximum line length: 120 characters
- Use double quotes for strings
- Prefer functional methods

### Running RuboCop

```bash
# Check all files
bundle exec rubocop

# Auto-fix safe issues
bundle exec rubocop -A

# Auto-fix all issues (use with caution)
bundle exec rubocop -a

# Check specific file
bundle exec rubocop app/models/cluster.rb
```

### Security Checks

```bash
# Brakeman - static security analysis
bundle exec brakeman

# Bundle Audit - check for vulnerable dependencies
bundle exec bundle-audit check --update
```

## Database Management

### Migrations

```bash
# Create a new migration
rails generate migration AddFieldToModel field:type

# Run pending migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database (WARNING: destructive)
rails db:reset

# Check migration status
rails db:migrate:status
```

### Seeds

```bash
# Load seed data
rails db:seed

# Reset and seed
rails db:reset
```

## Internationalization

### Adding Translations

1. Add keys to locale files:

```yaml
# config/locales/en.yml
en:
  clusters:
    title: "Clusters"
    create: "Create Cluster"
```

```yaml
# config/locales/ru.yml
ru:
  clusters:
    title: "Кластеры"
    create: "Создать кластер"
```

2. Use in views:

```erb
<h1><%= t('clusters.title') %></h1>
<%= link_to t('clusters.create'), new_cluster_path %>
```

### Documentation Translations

- Always update both README.md and README-RU.md
- Maintain identical line counts
- Follow guidelines in `.github/instructions/i18n-docs.md`

## Common Tasks

### Console

```bash
# Open Rails console
rails console

# Or use short form
rails c

# Production console (use with caution)
RAILS_ENV=production rails console
```

### Routes

```bash
# List all routes
rails routes

# Search routes
rails routes | grep cluster

# Expanded route info
rails routes --expanded
```

### Background Jobs

```bash
# Start Sidekiq
bundle exec sidekiq

# With specific queue
bundle exec sidekiq -q default -q mailers
```

## Troubleshooting

### Common Issues

1. **Bundle Install Fails**
   ```bash
   # Update bundler
   gem install bundler
   
   # Clean and reinstall
   bundle clean --force
   bundle install
   ```

2. **Database Connection Issues**
   - Verify DATABASE_URL in .env
   - Check Supabase project is running
   - Verify network connectivity

3. **Asset Compilation Issues**
   ```bash
   # Clear asset cache
   rails assets:clobber
   
   # Precompile assets
   rails assets:precompile
   ```

4. **Test Failures**
   ```bash
   # Reset test database
   RAILS_ENV=test rails db:reset
   
   # Clear test cache
   rails tmp:clear
   ```

### Getting Help

- Check [Constitution](/.specify/memory/constitution.md) for architectural decisions
- Review [Specifications](/specs/) for feature details
- Consult [GitHub Instructions](/.github/instructions/) for workflows
- Open an Issue for bugs or feature requests

## Best Practices

### Code Organization

- Follow MVC pattern strictly
- Use service objects for complex business logic
- Keep controllers thin
- Use concerns for shared behavior
- Organize code by feature (packages)

### Git Workflow

- Create feature branches from main
- Write clear commit messages
- Squash commits before merging
- Keep commits focused and atomic

### Documentation

- Update README files when adding features
- Document public APIs
- Add code comments for complex logic
- Maintain both English and Russian versions

### Performance

- Add database indexes for frequently queried columns
- Use eager loading to avoid N+1 queries
- Cache expensive operations
- Monitor with rack-mini-profiler in development

## Additional Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [Supabase Documentation](https://supabase.com/docs)
- [ViewComponent Guide](https://viewcomponent.org/)
- [Tailwind CSS Documentation](https://tailwindcss.com/)
