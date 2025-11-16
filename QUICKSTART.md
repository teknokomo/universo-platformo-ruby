# Universo Platformo Ruby - Quick Start Guide

## 🚀 Repository Overview

This is the Ruby on Rails implementation of Universo Platformo, a modular platform for building distributed applications with clusters, metaverses, and multiplayer capabilities.

## 📋 Key Documents

| Document | English | Russian | Purpose |
|----------|---------|---------|---------|
| **Overview** | [README.md](README.md) | [README-RU.md](README-RU.md) | Project introduction and quick start |
| **Development** | [DEVELOPMENT.md](DEVELOPMENT.md) | [DEVELOPMENT-RU.md](DEVELOPMENT-RU.md) | Detailed development guide |
| **Contributing** | [CONTRIBUTING.md](CONTRIBUTING.md) | [CONTRIBUTING-RU.md](CONTRIBUTING-RU.md) | How to contribute |
| **Review** | [PROJECT_REVIEW.md](PROJECT_REVIEW.md) | [PROJECT_REVIEW-RU.md](PROJECT_REVIEW-RU.md) | Comprehensive project review |

## ⚡ Quick Commands

```bash
# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate

# Run tests
bundle exec rspec

# Check code quality
bundle exec rubocop

# Security checks
bundle exec brakeman
bundle exec bundle-audit check --update

# Start server
rails server
```

## 🏗️ Project Structure

```
universo-platformo-ruby/
├── app/                    # Rails application code
├── config/                 # Configuration files
│   ├── locales/           # i18n (en, ru)
│   ├── application.rb     # Rails config
│   ├── database.yml       # Supabase/PostgreSQL
│   └── routes.rb          # Routes
├── db/                    # Database migrations
├── packages/              # Feature packages (monorepo)
│   └── PACKAGE_README_TEMPLATE.md
├── spec/                  # RSpec tests
├── .github/
│   └── instructions/      # GitHub workflows
├── .specify/
│   ├── memory/           # Project constitution
│   └── templates/        # Document templates
└── Gemfile               # Dependencies
```

## 🎯 Technology Stack

- **Ruby**: 3.2.3
- **Rails**: 7.1.2
- **Database**: PostgreSQL (Supabase)
- **Auth**: Devise + Supabase Auth
- **Testing**: RSpec, FactoryBot, Capybara
- **Code Quality**: RuboCop, Brakeman
- **UI**: ViewComponent, Tailwind CSS
- **I18n**: English (en) + Russian (ru)

## 📦 Creating Packages

New features are organized as packages in `packages/`:

```bash
# Create backend package
cd packages
rails plugin new feature-name-srv --mountable
mkdir -p feature-name-srv/base

# Create frontend package
mkdir -p feature-name-frt/base

# Create README files
touch feature-name-srv/README.md
touch feature-name-srv/README-RU.md
touch feature-name-frt/README.md
touch feature-name-frt/README-RU.md
```

## 🌍 Internationalization

All user-facing text uses Rails I18n:

```ruby
# In views
<%= t('clusters.title') %>

# In controllers
flash[:notice] = t('messages.success.created', model: 'Cluster')
```

Locale files: `config/locales/en.yml` and `config/locales/ru.yml`

## 📝 GitHub Workflow

1. **Create Issue** - Follow [.github/instructions/github-issues.md](.github/instructions/github-issues.md)
2. **Create Branch** - `git checkout -b feature/name`
3. **Make Changes** - Write code, tests, documentation
4. **Run Checks** - Tests, linting, security
5. **Create PR** - Follow [.github/instructions/github-pr.md](.github/instructions/github-pr.md)

## ✅ Project Status

- ✅ 100% requirements compliance (12/12)
- ✅ All documentation bilingual with exact line counts
- ✅ Rails application structure complete
- ✅ Testing framework configured
- ✅ Code quality tools configured
- ✅ Security scan passed (0 vulnerabilities)

## 🔗 Important Links

- **Constitution**: [.specify/memory/constitution.md](.specify/memory/constitution.md) - Core principles
- **Specifications**: [specs/](specs/) - Feature specifications
- **React Reference**: [universo-platformo-react](https://github.com/teknokomo/universo-platformo-react)

## 🆘 Need Help?

- Check [DEVELOPMENT.md](DEVELOPMENT.md) for detailed instructions
- Review [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- Read [PROJECT_REVIEW.md](PROJECT_REVIEW.md) for comprehensive overview
- Open an Issue for questions or bug reports

## 🚦 Next Steps

1. Install dependencies: `bundle install`
2. Setup database: `rails db:create && rails db:migrate`
3. Run tests: `bundle exec rspec`
4. Start development: Create first Issue for Clusters functionality

---

**Status**: 🟢 Ready for Development  
**Version**: Initial Setup Complete  
**Last Updated**: 2025-11-16
