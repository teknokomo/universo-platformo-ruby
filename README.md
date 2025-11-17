# Universo Platformo Ruby

Implementation of Universo Platformo / Universo MMOOMM / Universo Kiberplano built on Ruby on Rails and related Ruby stack.

## Overview

Universo Platformo Ruby is a Ruby on Rails implementation of the Universo Platformo ecosystem, a modular platform for building distributed applications with clusters, metaverses, and multiplayer capabilities. This implementation follows Ruby on Rails best practices while maintaining conceptual alignment with the [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react) reference implementation.

## Project Status

🚧 **In Development** - Initial setup phase

This project is currently in the initial setup phase. The repository structure, documentation, and core infrastructure are being established according to the project constitution and specifications.

## Architecture

### Modular Package Architecture

**ALL functionality** is organized as independent packages in the `packages/` directory. This modular approach enables:
- Parallel development of features
- Clear separation of concerns
- Independent testing and deployment
- **Future extraction**: Packages are designed as workspace packages in the monorepo initially, with the goal of extracting them into separate repositories as the project matures

### Monorepo Structure

The project uses a monorepo structure with packages organized in the `packages/` directory:

```
packages/
├── clusters-frt/     # Clusters frontend package
│   └── base/         # Base implementation
├── clusters-srv/     # Clusters backend package
│   └── base/         # Base implementation
└── ...               # Additional feature packages
```

**What goes in packages/:**
- All feature-specific code (models, controllers, views, components)
- Business logic for specific domains (clusters, metaverses, spaces, etc.)
- Feature-specific database migrations and tests
- Shared utility packages (universo-types, universo-utils, etc.)

**What stays in root application:**
- Application launcher and configuration files
- Main routes file that mounts package engines
- Shared application layouts
- Database and environment configuration

### Package Naming Convention

- **Frontend packages**: `<feature>-frt` (e.g., `clusters-frt`)
- **Backend packages**: `<feature>-srv` (e.g., `clusters-srv`)
- Each package contains a `base/` directory for core implementations, allowing future alternative implementations

### Technology Stack

- **Language**: Ruby 3.2+
- **Framework**: Ruby on Rails 7.0+
- **Database**: PostgreSQL via Supabase
- **Authentication**: Supabase Auth
- **Testing**: RSpec, FactoryBot, Capybara
- **Code Quality**: RuboCop, Brakeman, Bundler-audit
- **Frontend**: ViewComponent with Material Design styling

## Prerequisites

- Ruby 3.2 or higher
- PostgreSQL (via Supabase)
- Bundler
- Node.js (for asset compilation)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/teknokomo/universo-platformo-ruby.git
cd universo-platformo-ruby
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Environment

Copy the example environment file and configure your settings:

```bash
cp .env.example .env
```

Edit `.env` with your Supabase credentials:

```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
DATABASE_URL=your_database_url
```

### 4. Setup Database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Start the Application

```bash
rails server
```

Visit `http://localhost:3000` in your browser.

## Development

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/cluster_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Code Quality

```bash
# Run RuboCop linter
bundle exec rubocop

# Run security checks
bundle exec brakeman

# Check for vulnerable dependencies
bundle exec bundle-audit check --update
```

## Project Structure

```
.
├── .github/              # GitHub configurations and workflows
│   └── instructions/     # Guidelines for issues, PRs, labels
├── .specify/             # Specify AI tooling
│   ├── memory/          # Project constitution
│   └── templates/       # Document templates
├── packages/            # Feature packages (monorepo structure)
├── specs/               # Feature specifications
├── config/              # Rails configuration
├── app/                 # Rails application code
├── db/                  # Database migrations and seeds
└── spec/                # Test suite
```

## Core Features

### Clusters

The foundational feature implementing a three-tier hierarchy:

- **Clusters**: Top-level organizational units
- **Domains**: Mid-level units within clusters
- **Resources**: Individual resources within domains

This structure serves as a template for other features like Metaverses (Metaverses/Sections/Entities) and provides a consistent pattern throughout the platform.

## Documentation

- **[Constitution](/.specify/memory/constitution.md)**: Core principles and architectural decisions
- **[Specifications](/specs/)**: Detailed feature specifications
- **[GitHub Guidelines](/.github/instructions/)**: Workflows for issues, PRs, and labels
- **[Development Guide](DEVELOPMENT.md)**: Detailed development instructions (coming soon)

## Internationalization

This project supports multiple languages with English as the primary standard:

- All code comments and inline documentation are in English
- README files exist in both English (README.md) and Russian (README-RU.md)
- UI text uses Rails I18n framework with `en` and `ru` locales
- GitHub Issues include Russian translations in spoiler sections

## Contributing

1. Read the [GitHub Instructions](/.github/instructions/)
2. Create an Issue using the provided templates
3. Create a feature branch from your Issue
4. Submit a Pull Request following the PR guidelines
5. Ensure all tests pass and code quality checks succeed

## Reference Implementation

This project is inspired by and maintains conceptual alignment with [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react), adapting its architecture to Ruby on Rails best practices.

## License

[License information to be added]

## Links

- **Documentation**: [docs.universo.pro](https://docs.universo.pro) (coming soon)
- **React Implementation**: [universo-platformo-react](https://github.com/teknokomo/universo-platformo-react)
- **Website**: [universo.pro](https://universo.pro) (coming soon)
