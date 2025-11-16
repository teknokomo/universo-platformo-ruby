<!--
╔══════════════════════════════════════════════════════════════════════════════╗
║                        SYNC IMPACT REPORT                                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

VERSION CHANGE: Initial → 1.0.0

RATIONALE: Initial constitution for Universo Platformo Ruby project. MINOR version 
1.0.0 chosen as this represents the first stable governance framework.

MODIFIED PRINCIPLES:
- N/A (Initial version)

ADDED SECTIONS:
- I. Modular Package Architecture
- II. Rails Best Practices
- III. Database-First Design with Supabase
- IV. Internationalization (i18n)
- V. Documentation Standards
- VI. GitHub Workflow Integration
- Technology Stack Requirements
- Development Workflow

REMOVED SECTIONS:
- N/A (Initial version)

TEMPLATES REQUIRING UPDATES:
✅ plan-template.md - Reviewed, aligned with Ruby on Rails structure
✅ spec-template.md - Reviewed, compatible with modular package approach
✅ tasks-template.md - Reviewed, supports package-based task organization

FOLLOW-UP TODOS:
- None - All placeholders filled

COMPLIANCE NOTES:
- Constitution aligns with reference project (universo-platformo-react)
- Adapted for Ruby on Rails ecosystem
- Maintains bilingual documentation requirement (English/Russian)
- Preserves Universo Platformo architectural patterns

Last Updated: 2025-11-16
-->

# Universo Platformo Ruby Constitution

## Core Principles

### I. Modular Package Architecture

All functionality MUST be organized as independent packages within the monorepo structure. Each package represents a distinct feature domain (e.g., clusters, metaverses, spaces, authentication) and MUST:

- Be self-contained with clear boundaries and minimal dependencies
- Follow the `-frt` (frontend) and `-srv` (server) suffix naming convention when functionality requires both client and server components
- Include a `base/` subdirectory at the root to support future alternative implementations
- Have its own README.md and README-RU.md files documenting purpose, API, and usage
- Be independently testable using RSpec or equivalent Ruby testing frameworks
- Use Rails engines or similar modularization approaches to ensure proper isolation

**Rationale**: This modular structure enables parallel development, independent deployment, technology stack flexibility, and clear separation of concerns across the large Universo Platformo ecosystem.

### II. Rails Best Practices

All code MUST follow Ruby on Rails conventions and best practices. This is NON-NEGOTIABLE:

- Follow MVC (Model-View-Controller) architecture strictly
- Use Rails conventions for file organization, naming, and routing
- Leverage ActiveRecord for database interactions with proper validations and associations
- Apply service objects for complex business logic outside of models/controllers
- Use concerns for shared behavior across models or controllers
- Follow RESTful routing principles for API design
- Implement proper error handling and validation at all layers
- Use Rails generators where appropriate to maintain consistency

**Rationale**: Rails conventions provide proven patterns that reduce cognitive load, improve maintainability, and enable any Rails developer to quickly understand and contribute to the codebase.

### III. Database-First Design with Supabase

Database design and integration MUST prioritize Supabase while maintaining flexibility:

- Supabase MUST be the primary database backend for initial development
- All database schemas MUST be created with migrations that are version-controlled
- Database models MUST include proper indexes, constraints, and relationships
- Authentication MUST use Supabase Auth with appropriate session management
- Real-time subscriptions SHOULD leverage Supabase's real-time capabilities where applicable
- Code MUST be structured to allow future support for alternative databases (PostgreSQL, MySQL, etc.)
- Use database-level constraints and validations in addition to application-level validations

**Rationale**: Supabase provides powerful features for rapid development while maintaining PostgreSQL compatibility. Building with database flexibility ensures the platform can scale and adapt to different deployment scenarios.

### IV. Internationalization (i18n)

All user-facing content and documentation MUST support multiple languages with English as the primary standard:

- Code comments and inline documentation MUST be in English
- README files MUST exist in both English (README.md) and Russian (README-RU.md) with identical structure and line counts
- GitHub Issues MUST include English text with Russian translation in a `<details><summary>In Russian</summary>` spoiler section
- User interface text MUST use Rails i18n (I18n) framework with locale files for en and ru at minimum
- Translation files MUST be validated for completeness across all supported locales
- All new features MUST include translations at time of implementation, not as an afterthought

**Rationale**: Universo Platformo aims for global reach with strong support for Russian and English-speaking communities. Maintaining parallel translations ensures accessibility and prevents technical debt.

### V. Documentation Standards

Documentation MUST be comprehensive, current, and bilingual:

- Every package MUST have README.md and README-RU.md describing purpose, installation, configuration, and usage
- Complex features MUST have architecture documentation explaining design decisions
- API endpoints MUST be documented with expected inputs, outputs, and error responses
- Code MUST include clear comments for complex logic, but avoid obvious comments
- Documentation updates MUST be part of the same PR as code changes
- Follow the guidelines in `.github/instructions/i18n-docs.md` for all documentation work
- English documentation MUST always be updated first, followed by exact Russian translations

**Rationale**: High-quality documentation reduces onboarding time, prevents knowledge silos, and ensures the project can scale with multiple contributors across language barriers.

### VI. GitHub Workflow Integration

All development work MUST follow standardized GitHub workflows:

- Create GitHub Issues before implementing features using templates from `.github/instructions/github-issues.md`
- Apply appropriate labels according to `.github/instructions/github-labels.md`
- Create Pull Requests following `.github/instructions/github-pr.md` guidelines
- Link PRs to related Issues for traceability
- Ensure all PRs pass CI/CD checks before merging
- Use semantic commit messages (feat:, fix:, docs:, refactor:, test:, chore:)
- Request reviews from appropriate team members before merging

**Rationale**: Consistent workflows improve project organization, enable better tracking of work, and maintain quality through systematic review processes.

## Technology Stack Requirements

The following technology choices are MANDATORY for this project:

### Core Framework
- **Ruby on Rails**: Latest stable version (7.x or higher) with active support
- **Ruby**: Version 3.0 or higher
- **Bundler**: For dependency management (Ruby equivalent of PNPM in the React version)

### Database and Backend Services
- **Supabase**: Primary database and authentication provider
- **PostgreSQL**: Underlying database (via Supabase)
- **Supabase Auth**: For authentication and user management

### Frontend (when applicable in -frt packages)
- **ViewComponent** or **Hotwire (Turbo + Stimulus)**: For reactive frontend components
- **Material Design for Rails** or equivalent: UI component library aligned with Material UI used in React version
- **ERB/Slim templates**: For server-side rendering

### Testing
- **RSpec**: Primary testing framework for all packages
- **FactoryBot**: For test data generation
- **Capybara**: For integration and feature testing
- **SimpleCov**: For code coverage reporting

### Quality and Standards
- **RuboCop**: For code style enforcement
- **Brakeman**: For security vulnerability scanning
- **Bundler-audit**: For dependency vulnerability checking

### Deployment and Infrastructure
- **Docker**: For containerization and consistent environments
- **GitHub Actions**: For CI/CD pipelines

## Development Workflow

All development MUST follow this process:

### 1. Planning Phase
- Create detailed specifications using templates in `.specify/templates/`
- Review specifications against this constitution
- Identify affected packages and dependencies
- Create GitHub Issues with English and Russian descriptions

### 2. Implementation Phase
- Create feature branch from main with descriptive name
- Implement changes following Rails conventions
- Write or update tests (RSpec) alongside code changes
- Update or create package README files (both English and Russian)
- Run RuboCop and fix any style violations
- Ensure all tests pass locally

### 3. Review Phase
- Create Pull Request with clear description linking to Issue(s)
- Apply appropriate labels according to guidelines
- Request code review from team members
- Address review feedback promptly
- Ensure CI/CD checks pass (tests, linting, security scans)

### 4. Merge and Deployment
- Squash or merge commits as appropriate for clean history
- Delete feature branch after successful merge
- Monitor for any post-merge issues
- Update documentation if deployment process changes

## Governance

This constitution supersedes all other development practices and guidelines. All team members, contributors, and automated systems MUST comply with these principles.

### Amendment Process
- Amendments require documentation of the proposed change and rationale
- Significant changes (MAJOR version bumps) require team consensus
- All amendments must be version-controlled with clear changelog
- Breaking changes require migration plan for affected packages

### Compliance Verification
- All Pull Requests MUST be reviewed against this constitution
- Automated checks SHOULD enforce technical requirements where possible
- Any deviation from principles MUST be explicitly justified in PR description
- Constitution compliance is a mandatory gate for merging

### Complexity Justification
- Any complexity beyond standard Rails patterns MUST be justified
- Simpler alternatives MUST be documented and explained why they were rejected
- Technical debt introduced MUST be tracked with remediation plan

### Living Document
- This constitution is a living document that evolves with the project
- Version history is maintained with semantic versioning
- Regular reviews (quarterly minimum) to ensure relevance and effectiveness

**Version**: 1.0.0 | **Ratified**: 2025-11-16 | **Last Amended**: 2025-11-16
