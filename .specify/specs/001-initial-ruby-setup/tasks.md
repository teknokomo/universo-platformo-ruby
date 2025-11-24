# Tasks: Initial Platform Setup for Ruby Implementation

**Feature Branch**: `001-initial-ruby-setup`  
**Input**: Design documents from `/.specify/specs/001-initial-ruby-setup/`  
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/clusters-api.md, quickstart.md

**Tests**: Not explicitly requested in specification - testing infrastructure will be set up but test writing is deferred to implementation phase.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [ID] [P?] [Story?] Description`

- **Checkbox**: Always start with `- [ ]` (markdown checkbox)
- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story (US1, US2, US3, US4, US5, US6) - only for user story phases
- Include exact file paths in descriptions

## Path Conventions

This is a Rails monorepo using Engines for package management:
- **Root app**: `app/`, `config/`, `db/`, `spec/` (main Rails application)
- **Packages**: `packages/<feature>-srv/base/` or `packages/<feature>-frt/base/`
- **Documentation**: Root README files, package-specific READMEs
- **GitHub**: `.github/workflows/`, `.github/ISSUE_TEMPLATE/`, `.github/instructions/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Repository initialization, GitHub configuration, and documentation setup

- [ ] T001 Create `.gitignore` file with Ruby/Rails patterns (node_modules, .env, log/, tmp/, coverage/)
- [ ] T002 [P] Create `.ruby-version` file specifying Ruby 3.2.0
- [ ] T003 [P] Create `.env.example` with Supabase configuration template (SUPABASE_URL, SUPABASE_KEY, DATABASE_URL)
- [ ] T004 [P] Create GitHub issue labels following `.github/instructions/github-labels.md` conventions
- [ ] T005 [P] Create GitHub issue templates in `.github/ISSUE_TEMPLATE/` (bug.yml, feature.yml, enhancement.yml)
- [ ] T006 [P] Create GitHub pull request template in `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] T007 [P] Create README.md (English) at repository root with project overview, architecture, setup instructions
- [ ] T008 Create README-RU.md (Russian) at repository root - exact copy of README.md content translated to Russian with identical line count
- [ ] T009 [P] Create CONTRIBUTING.md (English) with contribution guidelines, code style, PR process
- [ ] T010 Create CONTRIBUTING-RU.md (Russian) - exact copy of CONTRIBUTING.md translated to Russian with identical line count
- [ ] T011 [P] Create DEVELOPMENT.md (English) with development environment setup, testing, debugging guide
- [ ] T012 Create DEVELOPMENT-RU.md (Russian) - exact copy of DEVELOPMENT.md translated to Russian with identical line count
- [ ] T013 [P] Create `.github/instructions/i18n-docs.md` documenting bilingual documentation requirements and verification process
- [ ] T014 [P] Create `.github/instructions/github-issues.md` documenting issue creation workflow and templates
- [ ] T015 [P] Create `.github/instructions/github-pr.md` documenting pull request workflow and requirements
- [ ] T016 [P] Create `.github/instructions/github-labels.md` documenting label taxonomy and usage
- [ ] T017 [P] Create `tools/check_i18n_docs.rb` script for bilingual documentation line count verification
- [ ] T018 [P] Create `.github/workflows/docs-i18n-check.yml` GitHub Actions workflow for automated documentation verification
- [ ] T019 [P] Create `.github/workflows/ci.yml` GitHub Actions workflow for tests, linting, security scanning

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T020 Initialize Rails 7.0+ application with `rails new . --database=postgresql --skip-git` (repository root)
- [ ] T021 [P] Configure `Gemfile` with core dependencies (Rails 7.0+, pg, supabase-rb, devise/custom auth, view_component, hotwire-rails, tailwindcss-rails)
- [ ] T022 [P] Configure `Gemfile` with test dependencies (rspec-rails, factory_bot_rails, capybara, selenium-webdriver, database_cleaner, simplecov)
- [ ] T023 [P] Configure `Gemfile` with development dependencies (rubocop, rubocop-rails, rubocop-rspec, brakeman, bundler-audit)
- [ ] T024 Run `bundle install` to install all dependencies
- [ ] T025 [P] Configure `config/database.yml` for Supabase PostgreSQL connection with environment variables
- [ ] T026 [P] Create `config/initializers/supabase.rb` initializer for Supabase client configuration
- [ ] T027 [P] Install RSpec with `rails generate rspec:install` and configure in `spec/rails_helper.rb`
- [ ] T028 [P] Configure FactoryBot in `spec/support/factory_bot.rb`
- [ ] T029 [P] Configure Capybara in `spec/support/capybara.rb` with Selenium WebDriver
- [ ] T030 [P] Configure SimpleCov in `spec/spec_helper.rb` for code coverage (80% minimum)
- [ ] T031 [P] Configure RuboCop in `.rubocop.yml` with Rails and RSpec extensions
- [ ] T032 [P] Create `config/initializers/cors.rb` for CORS configuration if API-only endpoints exist
- [ ] T033 [P] Configure `config/application.rb` with timezone, locale (en, ru), eager loading settings
- [ ] T034 [P] Create `app/controllers/concerns/api_error_handler.rb` concern for consistent API error responses
- [ ] T035 [P] Create `app/controllers/concerns/paginatable.rb` concern for pagination logic (page, per_page, sort_by, sort_order)
- [ ] T036 [P] Create `app/controllers/concerns/authenticatable.rb` concern for JWT authentication middleware
- [ ] T037 [P] Create `lib/supabase/auth_client.rb` wrapper for Supabase authentication operations
- [ ] T038 [P] Create `app/models/concerns/soft_deletable.rb` concern for soft delete functionality (discarded_at column)
- [ ] T039 [P] Configure Hotwire (Turbo + Stimulus) in `config/importmap.rb` and `app/javascript/application.js`
- [ ] T040 [P] Configure Tailwind CSS in `config/tailwind.config.js` with Material Design color palette
- [ ] T041 [P] Create base application layout in `app/views/layouts/application.html.erb` with Hotwire and Tailwind
- [ ] T042 [P] Create `app/controllers/application_controller.rb` with authentication and error handling includes
- [ ] T043 [P] Configure routes in `config/routes.rb` with API versioning namespace (`/api/v1`)
- [ ] T044 [P] Create `.github/workflows/tests.yml` GitHub Actions workflow for automated testing on PR
- [ ] T045 [P] Create `.github/workflows/security.yml` GitHub Actions workflow for Brakeman and Bundler-audit
- [ ] T046 [P] Create `.github/workflows/lint.yml` GitHub Actions workflow for RuboCop linting

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Repository Initialization (Priority: P1) 🎯 MVP Component

**Goal**: Developer can clone repository, understand project structure, and successfully run application with comprehensive bilingual documentation

**Independent Test**: Clone fresh repository, follow README instructions, verify application starts successfully and documentation is complete

**Dependencies**: Foundational phase (Phase 2) must be complete

### Implementation for User Story 1

- [ ] T047 [US1] Verify README.md includes project overview, architecture section, technology stack, quick start guide
- [ ] T048 [US1] Verify README-RU.md matches README.md line count exactly using `tools/check_i18n_docs.rb`
- [ ] T049 [US1] Verify CONTRIBUTING.md includes Git workflow, code style guidelines, PR checklist
- [ ] T050 [US1] Verify CONTRIBUTING-RU.md matches CONTRIBUTING.md line count exactly
- [ ] T051 [US1] Verify DEVELOPMENT.md includes environment setup, running tests, debugging tips
- [ ] T052 [US1] Verify DEVELOPMENT-RU.md matches DEVELOPMENT.md line count exactly
- [ ] T053 [US1] Create root `Rakefile` with custom tasks for checking i18n docs, running all tests
- [ ] T054 [US1] Test documentation verification script runs successfully: `ruby tools/check_i18n_docs.rb`
- [ ] T055 [US1] Test application starts successfully: `rails server` and verify at http://localhost:3000
- [ ] T056 [US1] Create simple welcome page at root route in `app/controllers/pages_controller.rb` and `app/views/pages/home.html.erb`
- [ ] T057 [US1] Verify all GitHub workflows pass (docs check, lint, security, tests)

**Checkpoint**: User Story 1 complete - documentation is comprehensive and verified, application runs successfully

---

## Phase 4: User Story 2 - Monorepo Structure Setup (Priority: P1) 🎯 MVP Component

**Goal**: Developer can organize functionality into separate packages with clear frontend/backend separation using Rails Engines

**Independent Test**: Create a sample package following conventions, verify it loads correctly, shared dependencies work

**Dependencies**: User Story 1 (repository setup)

### Implementation for User Story 2

- [ ] T058 [US2] Create `packages/` directory structure at repository root
- [ ] T059 [P] [US2] Create `packages/universo-types/base/` directory structure for shared types package
- [ ] T060 [P] [US2] Create `packages/universo-utils/base/` directory structure for shared utilities package
- [ ] T061 [P] [US2] Create `packages/universo-template/base/` directory structure for shared UI components package
- [ ] T062 [US2] Generate universo-types Rails Engine: `cd packages/universo-types/base && rails plugin new . --mountable --skip-git`
- [ ] T063 [US2] Generate universo-utils Rails Engine: `cd packages/universo-utils/base && rails plugin new . --mountable --skip-git`
- [ ] T064 [US2] Generate universo-template Rails Engine: `cd packages/universo-template/base && rails plugin new . --mountable --skip-git`
- [ ] T065 [P] [US2] Create `packages/universo-types/base/README.md` documenting shared concerns, validators, and type definitions
- [ ] T066 [P] [US2] Create `packages/universo-types/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T067 [P] [US2] Create `packages/universo-utils/base/README.md` documenting shared utility functions and helpers
- [ ] T068 [P] [US2] Create `packages/universo-utils/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T069 [P] [US2] Create `packages/universo-template/base/README.md` documenting ViewComponent library and Material Design components
- [ ] T070 [P] [US2] Create `packages/universo-template/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T071 [P] [US2] Create `packages/universo-types/base/app/models/concerns/role_based_access.rb` concern for role permissions
- [ ] T072 [P] [US2] Create `packages/universo-types/base/app/models/concerns/paginatable_model.rb` concern for pagination scopes
- [ ] T073 [P] [US2] Create `packages/universo-utils/base/lib/universo_utils/string_helpers.rb` for string utility functions
- [ ] T074 [P] [US2] Create `packages/universo-utils/base/lib/universo_utils/validation_helpers.rb` for custom validators
- [ ] T075 [P] [US2] Create `packages/universo-template/base/app/components/universo/button_component.rb` Material Design button ViewComponent
- [ ] T076 [P] [US2] Create `packages/universo-template/base/app/components/universo/card_component.rb` Material Design card ViewComponent
- [ ] T077 [US2] Add universo-types to root Gemfile with path dependency: `gem 'universo_types', path: 'packages/universo-types/base'`
- [ ] T078 [US2] Add universo-utils to root Gemfile with path dependency: `gem 'universo_utils', path: 'packages/universo-utils/base'`
- [ ] T079 [US2] Add universo-template to root Gemfile with path dependency: `gem 'universo_template', path: 'packages/universo-template/base'`
- [ ] T080 [US2] Run `bundle install` to register packages
- [ ] T081 [US2] Mount universo-template engine in `config/routes.rb`
- [ ] T082 [US2] Verify shared packages load correctly by using ButtonComponent in welcome page
- [ ] T083 [US2] Create PACKAGE_CREATION_GUIDE.md documenting package creation checklist and patterns
- [ ] T084 [US2] Create PACKAGE_CREATION_GUIDE-RU.md - exact Russian translation with identical line count

**Checkpoint**: User Story 2 complete - monorepo structure established with working shared packages

---

## Phase 5: User Story 3 - Database Integration (Priority: P2)

**Goal**: Application connects to Supabase PostgreSQL, performs CRUD operations, handles connection failures gracefully

**Independent Test**: Configure Supabase credentials, establish connection, create/read/update/delete test record, verify persistence

**Dependencies**: User Story 2 (monorepo structure for shared utilities)

### Implementation for User Story 3

- [ ] T085 [US3] Create database configuration in `config/database.yml` with Supabase connection string from ENV
- [ ] T086 [US3] Create `db/schema.rb` initial schema file
- [ ] T087 [P] [US3] Create `lib/supabase/database_client.rb` wrapper for database operations with connection pooling
- [ ] T088 [P] [US3] Create `app/models/concerns/database_health_check.rb` concern for connection health monitoring
- [ ] T089 [US3] Test database connection with `rails db:version`
- [ ] T090 [US3] Create health check endpoint in `app/controllers/health_controller.rb` with database connectivity test
- [ ] T091 [US3] Add health check route to `config/routes.rb` at `/health`
- [ ] T092 [P] [US3] Create `spec/lib/supabase/database_client_spec.rb` RSpec tests for database client
- [ ] T093 [P] [US3] Create `spec/requests/health_spec.rb` RSpec tests for health check endpoint
- [ ] T094 [US3] Document database setup in DEVELOPMENT.md section "Database Configuration"
- [ ] T095 [US3] Update DEVELOPMENT-RU.md with matching database setup documentation
- [ ] T096 [US3] Verify health check endpoint returns 200 OK when database connected
- [ ] T097 [US3] Verify health check endpoint returns 503 Service Unavailable when database disconnected

**Checkpoint**: User Story 3 complete - database connectivity established and health monitored

---

## Phase 6: User Story 4 - Authentication System (Priority: P2)

**Goal**: Users can register, log in, access protected routes securely using Supabase Auth with JWT tokens

**Independent Test**: Register new account, log in with correct credentials, attempt login with incorrect credentials, access protected route

**Dependencies**: User Story 3 (database for session storage if needed)

### Implementation for User Story 4

- [ ] T098 [US4] Configure Supabase Auth client in `config/initializers/supabase_auth.rb`
- [ ] T099 [P] [US4] Create `lib/supabase/auth_service.rb` for authentication operations (sign_up, sign_in, sign_out, verify_token)
- [ ] T100 [P] [US4] Create `app/controllers/concerns/authentication.rb` concern for authentication helpers (current_user, authenticate_user!)
- [ ] T101 [US4] Create `app/controllers/sessions_controller.rb` with new, create, destroy actions for login/logout
- [ ] T102 [US4] Create `app/controllers/registrations_controller.rb` with new, create actions for signup
- [ ] T103 [P] [US4] Create `app/views/sessions/new.html.erb` login form view with Material Design styling
- [ ] T104 [P] [US4] Create `app/views/registrations/new.html.erb` signup form view with Material Design styling
- [ ] T105 [US4] Add authentication routes to `config/routes.rb` (signup, login, logout paths)
- [ ] T106 [US4] Create `app/models/user.rb` virtual model for Supabase Auth users with helper methods
- [ ] T107 [P] [US4] Create `app/middleware/jwt_authentication.rb` middleware for API JWT token validation
- [ ] T108 [US4] Add JWT authentication middleware to `config/application.rb` for API routes
- [ ] T109 [P] [US4] Create `spec/lib/supabase/auth_service_spec.rb` RSpec tests for authentication service
- [ ] T110 [P] [US4] Create `spec/controllers/sessions_controller_spec.rb` RSpec tests for sessions controller
- [ ] T111 [P] [US4] Create `spec/controllers/registrations_controller_spec.rb` RSpec tests for registrations controller
- [ ] T112 [P] [US4] Create `spec/features/user_authentication_spec.rb` Capybara feature tests for login/logout flow
- [ ] T113 [US4] Test user registration flow manually
- [ ] T114 [US4] Test user login flow manually
- [ ] T115 [US4] Test protected route access (should redirect to login when not authenticated)
- [ ] T116 [US4] Document authentication setup in DEVELOPMENT.md section "Authentication Configuration"
- [ ] T117 [US4] Update DEVELOPMENT-RU.md with matching authentication documentation

**Checkpoint**: User Story 4 complete - authentication system functional with Supabase Auth integration

---

## Phase 7: User Story 5 - UI Framework Integration (Priority: P2)

**Goal**: Developers can create consistent, attractive UIs using ViewComponent + Hotwire + Tailwind CSS with Material Design

**Independent Test**: Create sample page with multiple UI components, verify Material Design styling, test responsive behavior

**Dependencies**: User Story 2 (universo-template package), User Story 4 (for protected UI pages)

### Implementation for User Story 5

- [ ] T118 [US5] Configure Tailwind CSS with Material Design color palette in `config/tailwind.config.js`
- [ ] T119 [P] [US5] Create Material Design color variables in `app/assets/stylesheets/application.tailwind.css`
- [ ] T120 [P] [US5] Create `app/components/universo/form_component.rb` ViewComponent for Material Design forms
- [ ] T121 [P] [US5] Create `app/components/universo/input_component.rb` ViewComponent for Material Design text inputs
- [ ] T122 [P] [US5] Create `app/components/universo/modal_component.rb` ViewComponent for Material Design modals
- [ ] T123 [P] [US5] Create `app/components/universo/list_component.rb` ViewComponent for Material Design lists
- [ ] T124 [P] [US5] Create `app/components/universo/navigation_component.rb` ViewComponent for navigation bar
- [ ] T125 [P] [US5] Create `app/javascript/controllers/modal_controller.js` Stimulus controller for modal interactions
- [ ] T126 [P] [US5] Create `app/javascript/controllers/form_validation_controller.js` Stimulus controller for form validation
- [ ] T127 [P] [US5] Create `app/javascript/controllers/autosave_controller.js` Stimulus controller for auto-save functionality
- [ ] T128 [US5] Create component showcase page in `app/controllers/styleguide_controller.rb` and `app/views/styleguide/index.html.erb`
- [ ] T129 [US5] Add styleguide route to `config/routes.rb`
- [ ] T130 [P] [US5] Create `spec/components/universo/button_component_spec.rb` RSpec tests for button component
- [ ] T131 [P] [US5] Create `spec/components/universo/card_component_spec.rb` RSpec tests for card component
- [ ] T132 [P] [US5] Create `spec/components/universo/form_component_spec.rb` RSpec tests for form component
- [ ] T133 [US5] Test component showcase page manually, verify all components render correctly
- [ ] T134 [US5] Test responsive design at 1920px (desktop), 768px (tablet), 375px (mobile) viewports
- [ ] T135 [US5] Document UI framework usage in DEVELOPMENT.md section "UI Components and Styling"
- [ ] T136 [US5] Update DEVELOPMENT-RU.md with matching UI framework documentation
- [ ] T137 [US5] Create UI_COMPONENT_GUIDE.md documenting ViewComponent creation patterns
- [ ] T138 [US5] Create UI_COMPONENT_GUIDE-RU.md - exact Russian translation with identical line count

**Checkpoint**: User Story 5 complete - UI framework integrated with Material Design components available

---

## Phase 8: User Story 6 - Clusters Core Functionality (Priority: P3)

**Goal**: Users can manage Clusters/Domains/Resources with full CRUD operations and hierarchical relationships

**Independent Test**: Create cluster, add domains, add resources to domains, perform CRUD on all entities, verify hierarchy preservation

**Dependencies**: All previous user stories (US1-US5) must be complete

### Implementation for User Story 6

#### Models and Database

- [ ] T139 [P] [US6] Create `packages/clusters-srv/` directory structure
- [ ] T140 [US6] Generate clusters-srv Rails Engine: `cd packages/clusters-srv/base && rails plugin new . --mountable --skip-git`
- [ ] T141 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_clusters.rb` for clusters table
- [ ] T142 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_domains.rb` for domains table
- [ ] T143 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_resources.rb` for resources table
- [ ] T144 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_junction_tables.rb` for ClusterDomain and DomainResource
- [ ] T145 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_cluster_members.rb` for cluster members with roles
- [ ] T146 [US6] Run migrations with `rails db:migrate`
- [ ] T147 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster.rb` model with validations and associations
- [ ] T148 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/domain.rb` model with validations and associations
- [ ] T149 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/resource.rb` model with validations and associations
- [ ] T150 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster_domain.rb` junction model
- [ ] T151 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/domain_resource.rb` junction model
- [ ] T152 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster_member.rb` model for role-based access
- [ ] T153 [US6] Add RoleBasedAccess concern to Cluster model for permission checking
- [ ] T154 [US6] Add SoftDeletable concern to Cluster, Domain, Resource models

#### Controllers and Routes

- [ ] T155 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/clusters_controller.rb` with CRUD actions
- [ ] T156 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/domains_controller.rb` with CRUD actions
- [ ] T157 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/resources_controller.rb` with CRUD actions
- [ ] T158 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/members_controller.rb` for member management
- [ ] T159 [US6] Include Paginatable and ApiErrorHandler concerns in all controllers
- [ ] T160 [US6] Add authorization checks (authenticate_user!, authorize_cluster_access!) to all controller actions
- [ ] T161 [US6] Configure routes in `packages/clusters-srv/base/config/routes.rb` with RESTful resources and relationship endpoints
- [ ] T162 [US6] Mount clusters engine in root `config/routes.rb` at `/api/v1/clusters`

#### Views and Components

- [ ] T163 [P] [US6] Create `packages/clusters-frt/` directory structure  
- [ ] T164 [US6] Generate clusters-frt Rails Engine: `cd packages/clusters-frt/base && rails plugin new . --mountable --skip-git`
- [ ] T165 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_card_component.rb` ViewComponent
- [ ] T166 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_list_component.rb` ViewComponent
- [ ] T167 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_form_component.rb` ViewComponent
- [ ] T168 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/domain_card_component.rb` ViewComponent
- [ ] T169 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/resource_card_component.rb` ViewComponent
- [ ] T170 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/index.html.erb` view
- [ ] T171 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/show.html.erb` view
- [ ] T172 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/new.html.erb` view
- [ ] T173 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/edit.html.erb` view
- [ ] T174 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/domains/index.html.erb` view
- [ ] T175 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/resources/index.html.erb` view

#### Stimulus Controllers

- [ ] T176 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/list_controller.js` for list interactions
- [ ] T177 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/form_controller.js` for form handling
- [ ] T178 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/hierarchy_controller.js` for hierarchical navigation

#### Tests

- [ ] T179 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/cluster_spec.rb` RSpec model tests
- [ ] T180 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/domain_spec.rb` RSpec model tests
- [ ] T181 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/resource_spec.rb` RSpec model tests
- [ ] T182 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/cluster_member_spec.rb` RSpec model tests
- [ ] T183 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/clusters_controller_spec.rb` controller tests
- [ ] T184 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/domains_controller_spec.rb` controller tests
- [ ] T185 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/resources_controller_spec.rb` controller tests
- [ ] T186 [P] [US6] Create `packages/clusters-srv/base/spec/requests/clusters/clusters_api_spec.rb` API integration tests
- [ ] T187 [P] [US6] Create `packages/clusters-srv/base/spec/features/clusters/cluster_management_spec.rb` Capybara feature tests
- [ ] T188 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/clusters.rb` FactoryBot factories
- [ ] T189 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/domains.rb` FactoryBot factories
- [ ] T190 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/resources.rb` FactoryBot factories

#### Documentation

- [ ] T191 [US6] Create `packages/clusters-srv/base/README.md` documenting Clusters package architecture, API endpoints, usage
- [ ] T192 [US6] Create `packages/clusters-srv/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T193 [US6] Create `packages/clusters-frt/base/README.md` documenting Clusters UI components and usage
- [ ] T194 [US6] Create `packages/clusters-frt/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T195 [US6] Add clusters-srv to root Gemfile with path dependency
- [ ] T196 [US6] Add clusters-frt to root Gemfile with path dependency
- [ ] T197 [US6] Run `bundle install` to register Clusters packages

#### Manual Testing and Validation

- [ ] T198 [US6] Test cluster creation through UI
- [ ] T199 [US6] Test domain creation and linking to cluster
- [ ] T200 [US6] Test resource creation and linking to domain
- [ ] T201 [US6] Test cluster deletion with domains (should fail)
- [ ] T202 [US6] Test domain deletion with resources (should fail)
- [ ] T203 [US6] Test role-based authorization (owner vs admin vs member permissions)
- [ ] T204 [US6] Test pagination on clusters list endpoint
- [ ] T205 [US6] Test API endpoints with Postman/curl (GET, POST, PATCH, DELETE)
- [ ] T206 [US6] Run full RSpec test suite: `bundle exec rspec packages/clusters-srv/base/spec/`
- [ ] T207 [US6] Verify test coverage meets 80% minimum using SimpleCov report

**Checkpoint**: User Story 6 complete - Clusters package fully functional as reference implementation

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple user stories, documentation verification, deployment readiness

- [ ] T208 [P] Run `rubocop -a` to auto-fix style issues across entire codebase
- [ ] T209 [P] Run `brakeman` security scanner and address any critical/high severity issues
- [ ] T210 [P] Run `bundle audit` to check for vulnerable gem dependencies
- [ ] T211 [P] Verify all bilingual documentation pairs match line counts using `ruby tools/check_i18n_docs.rb`
- [ ] T212 [P] Create FEATURE_PARITY.md documenting features implemented vs React repository with tracking sections
- [ ] T213 Create FEATURE_PARITY-RU.md - exact Russian translation with identical line count
- [ ] T214 [P] Create ARCHITECTURE.md documenting monorepo structure, package patterns, engine mounting
- [ ] T215 Create ARCHITECTURE-RU.md - exact Russian translation with identical line count
- [ ] T216 [P] Update root README.md with links to all documentation and package status
- [ ] T217 Update root README-RU.md to match README.md exactly
- [ ] T218 [P] Create `.github/workflows/deploy.yml` for automated deployment (structure only, no actual deployment)
- [ ] T219 [P] Create Docker configuration files: `Dockerfile` and `docker-compose.yml` for containerization
- [ ] T220 Verify all GitHub Actions workflows pass (docs, tests, lint, security)
- [ ] T221 Run quickstart.md validation - follow guide as new user and verify 15-minute setup
- [ ] T222 [P] Generate RSpec coverage report with SimpleCov and verify 80%+ coverage
- [ ] T223 [P] Create CHANGELOG.md documenting this initial release with all features
- [ ] T224 Create CHANGELOG-RU.md - exact Russian translation with identical line count
- [ ] T225 Tag release v0.1.0 with git tag

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: 
  - All depend on Foundational phase completion
  - US1 (Repository) → US2 (Monorepo) → sequential dependency
  - US3 (Database), US4 (Auth), US5 (UI) → can run in parallel after US2
  - US6 (Clusters) → depends on US2, US3, US4, US5 all complete
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

```
Phase 2 (Foundational)
    ↓
US1 (Repository Init) ──→ US2 (Monorepo)
                              ↓
                   ┌──────────┼──────────┐
                   ↓          ↓          ↓
              US3 (DB)   US4 (Auth)  US5 (UI)
                   └──────────┼──────────┘
                              ↓
                      US6 (Clusters)
                              ↓
                      Phase 9 (Polish)
```

- **User Story 1**: Can start after Foundational - No dependencies on other stories
- **User Story 2**: Depends on User Story 1 (needs basic repo structure)
- **User Story 3**: Depends on User Story 2 (needs shared utilities package)
- **User Story 4**: Depends on User Story 2 (needs shared types/concerns)
- **User Story 5**: Depends on User Story 2 (needs universo-template package)
- **User Story 6**: Depends on User Stories 2, 3, 4, 5 (needs monorepo, database, auth, UI)

### Within Each User Story

- Models before services
- Services before controllers
- Controllers before views
- Core implementation before tests
- Tests before story completion checkpoint

### Parallel Opportunities

**Phase 1 (Setup)**: All tasks marked [P] can run in parallel (T002-T003, T004-T006, T007-T019)

**Phase 2 (Foundational)**: Within phase, tasks marked [P] can run in parallel:
- Gemfile configuration tasks (T021-T023)
- Initializers (T025-T027)
- RSpec configuration (T027-T030)
- Concerns (T034-T038)
- Hotwire/Tailwind configuration (T039-T041)
- GitHub workflows (T044-T046)

**Phase 3 (US1)**: Minimal parallelization - mostly validation tasks

**Phase 4 (US2)**: Package creation tasks can run in parallel:
- Directory creation (T059-T061)
- README creation (T065-T070)
- Concern/utility creation (T071-T076)

**Phase 5 (US3)**: Database client and health check can be parallel (T087-T088)

**Phase 6 (US4)**: Service and controller creation can be parallel (T099-T100, T103-T104)

**Phase 7 (US5)**: ViewComponent and Stimulus controller creation highly parallel (T120-T127)

**Phase 8 (US6)**: Migrations (T141-T145), Models (T147-T152), Controllers (T155-T158), ViewComponents (T165-T169), Views (T170-T175), Stimulus (T176-T178), Tests (T179-T190) - all groups can be parallelized

**Phase 9 (Polish)**: Most documentation tasks can run in parallel (T208-T224)

---

## Parallel Example: User Story 6 (Clusters)

```bash
# Phase 1: Create all migrations in parallel
Task T141: Create clusters table migration
Task T142: Create domains table migration
Task T143: Create resources table migration
Task T144: Create junction tables migration
Task T145: Create cluster_members table migration

# Phase 2: Create all models in parallel (after migrations)
Task T147: Create Cluster model
Task T148: Create Domain model
Task T149: Create Resource model
Task T150: Create ClusterDomain model
Task T151: Create DomainResource model
Task T152: Create ClusterMember model

# Phase 3: Create all controllers in parallel (after models)
Task T155: Create ClustersController
Task T156: Create DomainsController
Task T157: Create ResourcesController
Task T158: Create MembersController

# Phase 4: Create all ViewComponents in parallel (after controllers)
Task T165: Create ClusterCardComponent
Task T166: Create ClusterListComponent
Task T167: Create ClusterFormComponent
Task T168: Create DomainCardComponent
Task T169: Create ResourceCardComponent
```

---

## Implementation Strategy

### MVP First (User Stories 1-2 Only)

1. Complete Phase 1: Setup (T001-T019)
2. Complete Phase 2: Foundational (T020-T046)
3. Complete Phase 3: User Story 1 - Repository (T047-T057)
4. Complete Phase 4: User Story 2 - Monorepo (T058-T084)
5. **STOP and VALIDATE**: Test monorepo structure, verify packages load
6. Deploy documentation/demo basic structure

### Incremental Delivery

1. Setup + Foundational → Foundation ready (T001-T046)
2. Add User Story 1 → Test repository setup → Deploy/Demo
3. Add User Story 2 → Test monorepo structure → Deploy/Demo
4. Add User Stories 3, 4, 5 in parallel → Test individually → Deploy/Demo
5. Add User Story 6 → Test Clusters → Deploy/Demo (full MVP!)
6. Polish phase → Final release

### Parallel Team Strategy

With multiple developers:

1. **Team completes Setup + Foundational together** (T001-T046)
2. Once Foundational done:
   - **Developer A**: User Story 1 + 2 (sequential, repo setup)
3. After US2 complete:
   - **Developer B**: User Story 3 (Database)
   - **Developer C**: User Story 4 (Authentication)
   - **Developer D**: User Story 5 (UI Framework)
4. After US3-5 complete:
   - **Team**: User Story 6 (Clusters) - subdivide by models/controllers/views/tests
5. **Team**: Polish phase together

---

## Success Criteria Mapping

Each task contributes to one or more success criteria from spec.md:

- **SC-001** (15-minute setup): T001-T057 (Setup + US1)
- **SC-002** (Documentation parity): T008, T010, T012, T017-T018, T211 (i18n verification)
- **SC-003** (Authentication): T098-T117 (US4)
- **SC-004** (Cluster creation): T139-T207 (US6)
- **SC-005** (100 concurrent users): T025, T037 (database pooling, connection management)
- **SC-006** (2-second page load): T039-T041, T118-T138 (Hotwire + Tailwind optimization)
- **SC-007** (Package creation in 10 min): T058-T084, T083-T084 (monorepo + guide)
- **SC-008** (Database uptime): T085-T097 (health monitoring)
- **SC-009** (Auth success rate): T098-T117 (robust auth implementation)
- **SC-010** (Visual consistency): T118-T138 (Material Design components)
- **SC-011** (Security): T209-T210, T044-T045 (Brakeman, Bundler-audit, CI)
- **SC-012** (Responsive design): T134 (viewport testing)
- **SC-013** (i18n verification): T017-T018, T211 (automated checks)
- **SC-014** (CI/CD checks): T044-T046, T220 (all workflows)
- **SC-015** (Package creation time): T058-T084 (streamlined process)

---

## Notes

- [P] tasks = different files, no dependencies, can run in parallel
- [Story] label maps task to specific user story (US1-US6) for traceability
- Each user story is independently completable and testable
- Verify documentation line counts match after each README creation
- Commit after each logical group of tasks (e.g., after completing all migrations)
- Stop at any checkpoint to validate story independently
- Rails Engine structure allows future extraction of packages to separate gems/repositories
- Testing infrastructure is set up but individual test writing happens during implementation
- All file paths assume Rails 7.0+ conventions with engines in packages/
- Tests not explicitly requested but testing infrastructure mandatory per constitution
- Bilingual documentation (EN/RU) is constitutional requirement with automated verification

---

**Total Tasks**: 225  
**Parallelizable Tasks**: ~120 (53%)  
**Estimated MVP (US1-2)**: 84 tasks  
**Estimated Full Implementation**: All 225 tasks

**Format Validation**: ✅ All tasks follow format: `- [ ] [ID] [P?] [Story?] Description with file path`
