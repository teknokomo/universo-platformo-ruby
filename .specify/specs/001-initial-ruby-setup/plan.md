# Implementation Plan: Initial Platform Setup for Ruby Implementation

**Branch**: `001-initial-ruby-setup` | **Date**: 2025-11-17 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-initial-ruby-setup/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Initialize Universo Platformo Ruby project with Rails-based monorepo structure using Rails Engines for package management. Establish repository documentation (bilingual English/Russian), configure Supabase database integration, implement Supabase authentication, integrate Hotwire + ViewComponent + Tailwind CSS for UI, and create the Clusters/Domains/Resources package as a reference implementation for future packages. The approach prioritizes Rails best practices and avoids porting React-specific patterns or legacy code from the reference implementation.

## Technical Context

**Language/Version**: Ruby 3.2+ with Rails 7.0+  
**Primary Dependencies**: Rails, Supabase (PostgreSQL + Auth), Hotwire (Turbo + Stimulus), ViewComponent, Tailwind CSS  
**Storage**: PostgreSQL via Supabase (cloud-hosted), with abstraction layer for future database system support  
**Testing**: RSpec for unit/integration tests, FactoryBot for fixtures, Capybara for feature tests, SimpleCov for coverage  
**Target Platform**: Linux/macOS server (containerized with Docker), web application accessible via modern browsers  
**Project Type**: Web application with Rails Engines package structure (monorepo)  
**Performance Goals**: <2s page load time, support 100 concurrent users, handle typical CRUD operations <200ms  
**Constraints**: Bilingual documentation (English/Russian with identical line counts), 80% minimum test coverage, Rails conventions mandatory  
**Scale/Scope**: Initial 6 user stories covering repository setup, monorepo structure, database, auth, UI framework, and Clusters functionality

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Constitution Compliance Review (v1.1.0)

**I. Modular Package Architecture** ✅
- Plan includes Rails Engines package structure with `-frt` and `-srv` suffixes
- Each package will have `base/` subdirectory for future implementations
- Bilingual README files required for each package
- Independent testing with RSpec

**II. Rails Best Practices** ✅
- MVC architecture mandatory
- Rails conventions for file organization and routing
- ActiveRecord for database with proper validations
- RESTful routing principles
- Service objects for complex logic

**III. Database-First Design with Supabase** ✅
- Supabase as primary backend (PostgreSQL + Auth)
- Version-controlled migrations
- Database abstraction for future flexibility
- Real-time capabilities available

**IV. Internationalization (i18n)** ✅
- README.md and README-RU.md with identical line counts
- Rails I18n framework for UI text (en, ru locales)
- GitHub Issues with English + Russian spoiler sections
- Translation validation required

**V. Documentation Standards** ✅
- Comprehensive package READMEs (bilingual)
- Architecture documentation for complex features
- API endpoint documentation
- Documentation updates in same PR as code

**VI. GitHub Workflow Integration** ✅
- GitHub Issue creation before features
- Labels per `.github/instructions/github-labels.md`
- PRs per `.github/instructions/github-pr.md`
- Semantic commit messages
- CI/CD checks required

**VII. React Repository Synchronization** ✅
- Monitor React repo for updates (explicitly noted in spec)
- Feature parity tracking document planned
- Avoid Flowise legacy code
- Feature parity over code parity

**Technology Stack Requirements** ✅
- Ruby 3.2+ and Rails 7.0+ ✓
- Supabase (PostgreSQL + Auth) ✓
- Hotwire (Turbo + Stimulus) ✓
- ViewComponent ✓
- Tailwind CSS with Material Design theme ✓
- RSpec, FactoryBot, Capybara ✓
- RuboCop, Brakeman, Bundler-audit ✓

**Explicit Exclusions** ✅
- No `docs/` folder in repository ✓
- User creates AI agent configs manually ✓
- Avoid React implementation flaws ✓
- No monolithic patterns ✓

**GATE STATUS: PASS** - All constitutional requirements met. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
# Rails monorepo with Rails Engines packages

# Root Rails application
app/
├── controllers/           # Main application controllers
├── models/               # Shared models (if any)
├── views/                # Main layouts and shared views
└── javascript/           # Hotwire Stimulus controllers

config/
├── routes.rb             # Main routes + engine mounts
├── database.yml          # Database configuration
└── initializers/         # Supabase, authentication setup

# Package structure
packages/
├── clusters-srv/         # Clusters backend (Rails Engine)
│   └── base/
│       ├── app/
│       │   ├── models/clusters/
│       │   ├── controllers/clusters/
│       │   └── views/clusters/
│       ├── config/routes.rb
│       ├── db/migrate/
│       ├── spec/
│       ├── README.md
│       └── README-RU.md
├── clusters-frt/         # Clusters frontend (ViewComponents + Stimulus)
│   └── base/
│       ├── app/
│       │   ├── components/clusters/
│       │   └── javascript/clusters/
│       ├── spec/
│       ├── README.md
│       └── README-RU.md
├── universo-types/       # Shared concerns and modules
│   └── base/
├── universo-utils/       # Shared utility functions
│   └── base/
└── universo-template/    # Shared ViewComponent library
    └── base/

# Testing
spec/
├── models/
├── controllers/
├── features/             # Capybara integration tests
└── factories/            # FactoryBot definitions

# Documentation
README.md                 # English (primary)
README-RU.md             # Russian (identical structure)
CONTRIBUTING.md
CONTRIBUTING-RU.md
DEVELOPMENT.md
DEVELOPMENT-RU.md

# GitHub configuration
.github/
├── workflows/            # CI/CD (tests, linting, security)
├── ISSUE_TEMPLATE/
├── PULL_REQUEST_TEMPLATE.md
└── instructions/         # Project guidelines
```

**Structure Decision**: Rails monorepo using Rails Engines for package isolation. Each package is a separate engine that can be independently developed, tested, and potentially extracted as a gem. The main application mounts these engines and provides shared infrastructure (authentication, database connections, layout). This structure follows Rails conventions while maintaining the modular package architecture required by the constitution.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations identified. All requirements align with constitutional principles.
