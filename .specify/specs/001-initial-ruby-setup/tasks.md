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

## Phase 5.5: Row-Level Security Setup (Required for FR-087 to FR-095)

**Goal**: Implement PostgreSQL Row-Level Security (RLS) policies for data isolation at database level

**Purpose**: Defense-in-depth security - database-level authorization prevents data leaks even if application logic fails

**Dependencies**: User Story 3 (Database Integration) must be complete

### Implementation for RLS

- [ ] T097.1 [P] Create `db/migrate/YYYYMMDDHHMMSS_enable_rls_for_clusters.rb` migration to enable RLS on clusters tables
- [ ] T097.2 [P] Create `db/migrate/YYYYMMDDHHMMSS_create_cluster_rls_policies.rb` with isolation policies
- [ ] T097.3 [P] Create `app/middleware/rls_context_middleware.rb` to propagate JWT claims to PostgreSQL session
- [ ] T097.4 [US3] Configure RLS middleware in `config/application.rb` for API routes
- [ ] T097.5 [P] Create `spec/support/rls_helpers.rb` for RLS testing helpers (with_rls_context)
- [ ] T097.6 [P] Create `spec/integration/rls_isolation_spec.rb` tests for RLS policy verification
- [ ] T097.7 [US3] Document RLS setup in DEVELOPMENT.md section "Row-Level Security Configuration"
- [ ] T097.8 [US3] Update DEVELOPMENT-RU.md with matching RLS documentation
- [ ] T097.9 [US3] Verify RLS policies prevent cross-user data access in tests

**Note**: RLS policies will be created for each package's tables. The Clusters package (Phase 8) will be the first to implement RLS policies on its tables.

**Checkpoint**: RLS infrastructure ready - database-level security configured

---

## Phase 6: User Story 4 - Authentication System (Priority: P2)

**Goal**: Users can register, log in, access protected routes securely using Supabase Auth with JWT tokens. Authentication is implemented as a dedicated package (auth-srv/auth-frt) to match React repository structure and allow future extraction.

**Independent Test**: Register new account, log in with correct credentials, attempt login with incorrect credentials, access protected route

**Dependencies**: User Story 3 (database for session storage if needed)

**Note**: Authentication is implemented as a package (auth-srv, auth-frt) to match React repository structure at https://github.com/teknokomo/universo-platformo-react/tree/main/packages/auth-srv

### Implementation for User Story 4

#### Auth Server Package (auth-srv)

- [ ] T098 [P] [US4] Create `packages/auth-srv/` directory structure
- [ ] T099 [US4] Generate auth-srv Rails Engine: `cd packages/auth-srv/base && rails plugin new . --mountable --skip-git`
- [ ] T100 [US4] Configure `packages/auth-srv/base/auth_srv.gemspec` with Supabase dependencies
- [ ] T101 [P] [US4] Create `packages/auth-srv/base/lib/auth_srv/supabase_client.rb` for Supabase Auth API wrapper
- [ ] T102 [P] [US4] Create `packages/auth-srv/base/app/services/auth_srv/authentication_service.rb` for sign_up, sign_in, sign_out, verify_token
- [ ] T103 [P] [US4] Create `packages/auth-srv/base/app/services/auth_srv/jwt_service.rb` for JWT token operations
- [ ] T104 [P] [US4] Create `packages/auth-srv/base/app/controllers/auth_srv/sessions_controller.rb` with create, destroy actions
- [ ] T105 [P] [US4] Create `packages/auth-srv/base/app/controllers/auth_srv/registrations_controller.rb` with create action
- [ ] T106 [P] [US4] Create `packages/auth-srv/base/app/controllers/auth_srv/passwords_controller.rb` for password reset
- [ ] T107 [US4] Create `packages/auth-srv/base/app/models/auth_srv/user.rb` virtual model for Supabase Auth users
- [ ] T108 [US4] Create `packages/auth-srv/base/app/controllers/concerns/auth_srv/authenticatable.rb` concern for controllers
- [ ] T109 [US4] Configure routes in `packages/auth-srv/base/config/routes.rb` with auth endpoints
- [ ] T110 [P] [US4] Create `packages/auth-srv/base/app/middleware/auth_srv/jwt_authentication.rb` middleware for API JWT validation
- [ ] T111 [P] [US4] Create `packages/auth-srv/base/app/middleware/auth_srv/rls_context.rb` middleware for RLS JWT propagation
- [ ] T112 [P] [US4] Create `packages/auth-srv/base/README.md` documenting authentication package
- [ ] T113 [US4] Create `packages/auth-srv/base/README-RU.md` - exact Russian translation with identical line count

#### Auth Frontend Package (auth-frt)

- [ ] T114 [P] [US4] Create `packages/auth-frt/` directory structure
- [ ] T115 [US4] Generate auth-frt Rails Engine: `cd packages/auth-frt/base && rails plugin new . --mountable --skip-git`
- [ ] T116 [P] [US4] Create `packages/auth-frt/base/app/components/auth_frt/login_form_component.rb` ViewComponent
- [ ] T117 [P] [US4] Create `packages/auth-frt/base/app/components/auth_frt/signup_form_component.rb` ViewComponent
- [ ] T118 [P] [US4] Create `packages/auth-frt/base/app/components/auth_frt/password_reset_component.rb` ViewComponent
- [ ] T119 [P] [US4] Create `packages/auth-frt/base/app/javascript/auth_frt/controllers/login_controller.js` Stimulus controller
- [ ] T120 [P] [US4] Create `packages/auth-frt/base/app/javascript/auth_frt/controllers/signup_controller.js` Stimulus controller
- [ ] T121 [P] [US4] Create `packages/auth-frt/base/README.md` documenting auth frontend components
- [ ] T122 [US4] Create `packages/auth-frt/base/README-RU.md` - exact Russian translation with identical line count

#### Integration and Testing

- [ ] T123 [US4] Add auth-srv to root Gemfile with path dependency
- [ ] T124 [US4] Add auth-frt to root Gemfile with path dependency
- [ ] T125 [US4] Run `bundle install` to register auth packages
- [ ] T126 [US4] Mount auth-srv engine in root `config/routes.rb` at `/api/v1/auth`
- [ ] T127 [US4] Configure Supabase Auth client in `config/initializers/supabase_auth.rb`
- [ ] T128 [US4] Add JWT authentication middleware to `config/application.rb` for API routes
- [ ] T129 [P] [US4] Create `packages/auth-srv/base/spec/services/authentication_service_spec.rb` RSpec tests
- [ ] T130 [P] [US4] Create `packages/auth-srv/base/spec/controllers/sessions_controller_spec.rb` RSpec tests
- [ ] T131 [P] [US4] Create `packages/auth-srv/base/spec/controllers/registrations_controller_spec.rb` RSpec tests
- [ ] T132 [P] [US4] Create `spec/features/user_authentication_spec.rb` Capybara feature tests for login/logout flow
- [ ] T133 [US4] Test user registration flow manually
- [ ] T134 [US4] Test user login flow manually
- [ ] T135 [US4] Test protected route access (should redirect to login when not authenticated)
- [ ] T136 [US4] Document authentication setup in DEVELOPMENT.md section "Authentication Configuration"
- [ ] T137 [US4] Update DEVELOPMENT-RU.md with matching authentication documentation

**Checkpoint**: User Story 4 complete - authentication system functional with dedicated auth-srv and auth-frt packages

---

## Phase 7: User Story 5 - UI Framework Integration (Priority: P2)

**Goal**: Developers can create consistent, attractive UIs using ViewComponent + Hotwire + Tailwind CSS with Material Design

**Independent Test**: Create sample page with multiple UI components, verify Material Design styling, test responsive behavior

**Dependencies**: User Story 2 (universo-template package), User Story 4 (for protected UI pages)

### Implementation for User Story 5

- [ ] T138 [US5] Configure Tailwind CSS with Material Design color palette in `config/tailwind.config.js`
- [ ] T139 [P] [US5] Create Material Design color variables in `app/assets/stylesheets/application.tailwind.css`
- [ ] T140 [P] [US5] Create `app/components/universo/form_component.rb` ViewComponent for Material Design forms
- [ ] T141 [P] [US5] Create `app/components/universo/input_component.rb` ViewComponent for Material Design text inputs
- [ ] T142 [P] [US5] Create `app/components/universo/modal_component.rb` ViewComponent for Material Design modals
- [ ] T143 [P] [US5] Create `app/components/universo/list_component.rb` ViewComponent for Material Design lists
- [ ] T144 [P] [US5] Create `app/components/universo/navigation_component.rb` ViewComponent for navigation bar
- [ ] T145 [P] [US5] Create `app/javascript/controllers/modal_controller.js` Stimulus controller for modal interactions
- [ ] T146 [P] [US5] Create `app/javascript/controllers/form_validation_controller.js` Stimulus controller for form validation
- [ ] T147 [P] [US5] Create `app/javascript/controllers/autosave_controller.js` Stimulus controller for auto-save functionality
- [ ] T148 [US5] Create component showcase page in `app/controllers/styleguide_controller.rb` and `app/views/styleguide/index.html.erb`
- [ ] T149 [US5] Add styleguide route to `config/routes.rb`
- [ ] T150 [P] [US5] Create `spec/components/universo/button_component_spec.rb` RSpec tests for button component
- [ ] T151 [P] [US5] Create `spec/components/universo/card_component_spec.rb` RSpec tests for card component
- [ ] T152 [P] [US5] Create `spec/components/universo/form_component_spec.rb` RSpec tests for form component
- [ ] T153 [US5] Test component showcase page manually, verify all components render correctly
- [ ] T154 [US5] Test responsive design at 1920px (desktop), 768px (tablet), 375px (mobile) viewports
- [ ] T155 [US5] Document UI framework usage in DEVELOPMENT.md section "UI Components and Styling"
- [ ] T156 [US5] Update DEVELOPMENT-RU.md with matching UI framework documentation
- [ ] T157 [US5] Create UI_COMPONENT_GUIDE.md documenting ViewComponent creation patterns
- [ ] T158 [US5] Create UI_COMPONENT_GUIDE-RU.md - exact Russian translation with identical line count

**Checkpoint**: User Story 5 complete - UI framework integrated with Material Design components available

---

## Phase 8: User Story 6 - Clusters Core Functionality (Priority: P3)

**Goal**: Users can manage Clusters/Domains/Resources with full CRUD operations and hierarchical relationships

**Independent Test**: Create cluster, add domains, add resources to domains, perform CRUD on all entities, verify hierarchy preservation

**Dependencies**: All previous user stories (US1-US5) must be complete

### Implementation for User Story 6

#### Models and Database

- [ ] T159 [P] [US6] Create `packages/clusters-srv/` directory structure
- [ ] T160 [US6] Generate clusters-srv Rails Engine: `cd packages/clusters-srv/base && rails plugin new . --mountable --skip-git`
- [ ] T161 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_clusters.rb` for clusters table
- [ ] T162 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_domains.rb` for domains table
- [ ] T163 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_resources.rb` for resources table
- [ ] T164 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_junction_tables.rb` for ClusterDomain and DomainResource
- [ ] T165 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_create_clusters_cluster_members.rb` for cluster members with roles
- [ ] T166 [P] [US6] Create migration `db/migrate/YYYYMMDDHHMMSS_enable_rls_for_clusters_tables.rb` for RLS policies on clusters tables
- [ ] T167 [US6] Run migrations with `rails db:migrate`
- [ ] T168 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster.rb` model with validations and associations
- [ ] T169 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/domain.rb` model with validations and associations
- [ ] T170 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/resource.rb` model with validations and associations
- [ ] T171 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster_domain.rb` junction model
- [ ] T172 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/domain_resource.rb` junction model
- [ ] T173 [P] [US6] Create `packages/clusters-srv/base/app/models/clusters/cluster_member.rb` model for role-based access
- [ ] T174 [US6] Add RoleBasedAccess concern to Cluster model for permission checking
- [ ] T175 [US6] Add SoftDeletable concern to Cluster, Domain, Resource models

#### Controllers and Routes

- [ ] T176 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/clusters_controller.rb` with CRUD actions
- [ ] T177 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/domains_controller.rb` with CRUD actions
- [ ] T178 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/resources_controller.rb` with CRUD actions
- [ ] T179 [P] [US6] Create `packages/clusters-srv/base/app/controllers/clusters/members_controller.rb` for member management
- [ ] T180 [US6] Include Paginatable and ApiErrorHandler concerns in all controllers
- [ ] T181 [US6] Add authorization checks (authenticate_user!, authorize_cluster_access!) to all controller actions
- [ ] T182 [US6] Configure routes in `packages/clusters-srv/base/config/routes.rb` with RESTful resources and relationship endpoints
- [ ] T183 [US6] Mount clusters engine in root `config/routes.rb` at `/api/v1/clusters`

#### Views and Components

- [ ] T184 [P] [US6] Create `packages/clusters-frt/` directory structure  
- [ ] T185 [US6] Generate clusters-frt Rails Engine: `cd packages/clusters-frt/base && rails plugin new . --mountable --skip-git`
- [ ] T186 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_card_component.rb` ViewComponent
- [ ] T187 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_list_component.rb` ViewComponent
- [ ] T188 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/cluster_form_component.rb` ViewComponent
- [ ] T189 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/domain_card_component.rb` ViewComponent
- [ ] T190 [P] [US6] Create `packages/clusters-frt/base/app/components/clusters/resource_card_component.rb` ViewComponent
- [ ] T191 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/index.html.erb` view
- [ ] T192 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/show.html.erb` view
- [ ] T193 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/new.html.erb` view
- [ ] T194 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/clusters/edit.html.erb` view
- [ ] T195 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/domains/index.html.erb` view
- [ ] T196 [P] [US6] Create `packages/clusters-srv/base/app/views/clusters/resources/index.html.erb` view

#### Stimulus Controllers

- [ ] T197 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/list_controller.js` for list interactions
- [ ] T198 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/form_controller.js` for form handling
- [ ] T199 [P] [US6] Create `packages/clusters-frt/base/app/javascript/clusters/controllers/hierarchy_controller.js` for hierarchical navigation

#### Tests

- [ ] T200 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/cluster_spec.rb` RSpec model tests
- [ ] T201 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/domain_spec.rb` RSpec model tests
- [ ] T202 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/resource_spec.rb` RSpec model tests
- [ ] T203 [P] [US6] Create `packages/clusters-srv/base/spec/models/clusters/cluster_member_spec.rb` RSpec model tests
- [ ] T204 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/clusters_controller_spec.rb` controller tests
- [ ] T205 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/domains_controller_spec.rb` controller tests
- [ ] T206 [P] [US6] Create `packages/clusters-srv/base/spec/controllers/clusters/resources_controller_spec.rb` controller tests
- [ ] T207 [P] [US6] Create `packages/clusters-srv/base/spec/requests/clusters/clusters_api_spec.rb` API integration tests
- [ ] T208 [P] [US6] Create `packages/clusters-srv/base/spec/features/clusters/cluster_management_spec.rb` Capybara feature tests
- [ ] T209 [P] [US6] Create `packages/clusters-srv/base/spec/integration/clusters/rls_isolation_spec.rb` RLS policy tests
- [ ] T210 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/clusters.rb` FactoryBot factories
- [ ] T211 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/domains.rb` FactoryBot factories
- [ ] T212 [P] [US6] Create `packages/clusters-srv/base/spec/factories/clusters/resources.rb` FactoryBot factories

#### Documentation

- [ ] T213 [US6] Create `packages/clusters-srv/base/README.md` documenting Clusters package architecture, API endpoints, usage
- [ ] T214 [US6] Create `packages/clusters-srv/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T215 [US6] Create `packages/clusters-frt/base/README.md` documenting Clusters UI components and usage
- [ ] T216 [US6] Create `packages/clusters-frt/base/README-RU.md` - exact Russian translation with identical line count
- [ ] T217 [US6] Add clusters-srv to root Gemfile with path dependency
- [ ] T218 [US6] Add clusters-frt to root Gemfile with path dependency
- [ ] T219 [US6] Run `bundle install` to register Clusters packages

#### Manual Testing and Validation

- [ ] T220 [US6] Test cluster creation through UI
- [ ] T221 [US6] Test domain creation and linking to cluster
- [ ] T222 [US6] Test resource creation and linking to domain
- [ ] T223 [US6] Test cluster deletion with domains (should fail)
- [ ] T224 [US6] Test domain deletion with resources (should fail)
- [ ] T225 [US6] Test role-based authorization (owner vs admin vs member permissions)
- [ ] T226 [US6] Test RLS data isolation (user cannot access other user's clusters)
- [ ] T227 [US6] Test pagination on clusters list endpoint
- [ ] T228 [US6] Test API endpoints with Postman/curl (GET, POST, PATCH, DELETE)
- [ ] T229 [US6] Run full RSpec test suite: `bundle exec rspec packages/clusters-srv/base/spec/`
- [ ] T230 [US6] Verify test coverage meets 80% minimum using SimpleCov report

**Checkpoint**: User Story 6 complete - Clusters package fully functional as reference implementation

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements affecting multiple user stories, documentation verification, deployment readiness

- [ ] T231 [P] Run `rubocop -a` to auto-fix style issues across entire codebase
- [ ] T232 [P] Run `brakeman` security scanner and address any critical/high severity issues
- [ ] T233 [P] Run `bundle audit` to check for vulnerable gem dependencies
- [ ] T234 [P] Verify all bilingual documentation pairs match line counts using `ruby tools/check_i18n_docs.rb` (including package READMEs)
- [ ] T235 [P] Create FEATURE_PARITY.md documenting features implemented vs React repository with tracking sections
- [ ] T236 Create FEATURE_PARITY-RU.md - exact Russian translation with identical line count
- [ ] T237 [P] Create ARCHITECTURE.md documenting monorepo structure, package patterns, engine mounting
- [ ] T238 Create ARCHITECTURE-RU.md - exact Russian translation with identical line count
- [ ] T239 [P] Update root README.md with links to all documentation and package status
- [ ] T240 Update root README-RU.md to match README.md exactly
- [ ] T241 [P] Create `.github/workflows/deploy.yml` for automated deployment (structure only, no actual deployment)
- [ ] T242 [P] Create Docker configuration files: `Dockerfile` and `docker-compose.yml` for containerization
- [ ] T243 Verify all GitHub Actions workflows pass (docs, tests, lint, security)
- [ ] T244 Run quickstart.md validation - follow guide as new user and verify 15-minute setup
- [ ] T245 [P] Generate RSpec coverage report with SimpleCov and verify 80%+ coverage
- [ ] T246 [P] Create CHANGELOG.md documenting this initial release with all features
- [ ] T247 Create CHANGELOG-RU.md - exact Russian translation with identical line count
- [ ] T248 Tag release v0.1.0 with git tag

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: 
  - All depend on Foundational phase completion
  - US1 (Repository) → US2 (Monorepo) → sequential dependency
  - US3 (Database) → Phase 5.5 (RLS) → US4 (Auth packages) - sequential for security
  - US4 (Auth), US5 (UI) → can run in parallel after US2 + US3 + RLS
  - US6 (Clusters) → depends on US2, US3, RLS, US4, US5 all complete
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

```
Phase 2 (Foundational)
    ↓
US1 (Repository Init) ──→ US2 (Monorepo)
                              ↓
                         US3 (DB)
                              ↓
                      Phase 5.5 (RLS)
                              ↓
                   ┌──────────┼──────────┐
                   ↓          ↓          ↓
           US4 (Auth)   US5 (UI)     (parallel)
              (auth-srv/frt)
                   └──────────┼──────────┘
                              ↓
                      US6 (Clusters)
                         (clusters-srv/frt)
                              ↓
                      Phase 9 (Polish)
```

- **User Story 1**: Can start after Foundational - No dependencies on other stories
- **User Story 2**: Depends on User Story 1 (needs basic repo structure)
- **User Story 3**: Depends on User Story 2 (needs shared utilities package)
- **Phase 5.5 RLS**: Depends on User Story 3 (needs database connection)
- **User Story 4**: Depends on Phase 5.5 (auth-srv needs RLS middleware); creates auth-srv and auth-frt packages
- **User Story 5**: Depends on User Story 2 (needs universo-template package)
- **User Story 6**: Depends on User Stories 2, 3, RLS, 4, 5 (needs monorepo, database, RLS, auth, UI); creates clusters-srv and clusters-frt packages

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

**Phase 5.5 (RLS)**: Migrations and middleware can be parallel (T097.1-T097.3)

**Phase 6 (US4)**: Auth package tasks can run in parallel:
- Auth-srv services (T101-T103)
- Auth-frt components (T116-T120)
- Tests (T129-T132)

**Phase 7 (US5)**: ViewComponent and Stimulus controller creation highly parallel (T140-T147)

**Phase 8 (US6)**: Migrations (T161-T166), Models (T168-T173), Controllers (T176-T179), ViewComponents (T186-T190), Views (T191-T196), Stimulus (T197-T199), Tests (T200-T212) - all groups can be parallelized

**Phase 9 (Polish)**: Most documentation tasks can run in parallel (T231-T247)

---

## Parallel Example: User Story 6 (Clusters)

```bash
# Phase 1: Create all migrations in parallel
Task T161: Create clusters table migration
Task T162: Create domains table migration
Task T163: Create resources table migration
Task T164: Create junction tables migration
Task T165: Create cluster_members table migration
Task T166: Create RLS policies migration

# Phase 2: Create all models in parallel (after migrations)
Task T168: Create Cluster model
Task T169: Create Domain model
Task T170: Create Resource model
Task T171: Create ClusterDomain model
Task T172: Create DomainResource model
Task T173: Create ClusterMember model

# Phase 3: Create all controllers in parallel (after models)
Task T176: Create ClustersController
Task T177: Create DomainsController
Task T178: Create ResourcesController
Task T179: Create MembersController

# Phase 4: Create all ViewComponents in parallel (after controllers)
Task T186: Create ClusterCardComponent
Task T187: Create ClusterListComponent
Task T188: Create ClusterFormComponent
Task T189: Create DomainCardComponent
Task T190: Create ResourceCardComponent
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
4. Add User Story 3 + Phase 5.5 (RLS) → Test database + security
5. Add User Stories 4 (Auth packages), 5 (UI) in parallel → Test individually → Deploy/Demo
6. Add User Story 6 → Test Clusters with full RLS → Deploy/Demo (full MVP!)
7. Polish phase → Final release

### Parallel Team Strategy

With multiple developers:

1. **Team completes Setup + Foundational together** (T001-T046)
2. Once Foundational done:
   - **Developer A**: User Story 1 + 2 (sequential, repo setup)
3. After US2 complete:
   - **Developer B**: User Story 3 (Database) + Phase 5.5 (RLS)
   - **Developer C**: (wait for RLS) → User Story 4 (Auth packages: auth-srv, auth-frt)
   - **Developer D**: User Story 5 (UI Framework)
4. After US3, RLS, US4, US5 complete:
   - **Team**: User Story 6 (Clusters packages: clusters-srv, clusters-frt) - subdivide by models/controllers/views/tests
5. **Team**: Polish phase together

---

## Success Criteria Mapping

Each task contributes to one or more success criteria from spec.md:

- **SC-001** (15-minute setup): T001-T057 (Setup + US1)
- **SC-002** (Documentation parity): T008, T010, T012, T017-T018, T234 (i18n verification including packages)
- **SC-003** (Authentication): T098-T137 (US4 - auth-srv and auth-frt packages)
- **SC-004** (Cluster creation): T159-T230 (US6 - clusters-srv and clusters-frt packages)
- **SC-005** (100 concurrent users): T025, T037 (database pooling, connection management)
- **SC-006** (2-second page load): T039-T041, T138-T158 (Hotwire + Tailwind optimization)
- **SC-007** (Package creation in 10 min): T058-T084, T083-T084 (monorepo + guide)
- **SC-008** (Database uptime): T085-T097 (health monitoring)
- **SC-009** (Auth success rate): T098-T137 (robust auth-srv/auth-frt implementation)
- **SC-010** (Visual consistency): T138-T158 (Material Design components)
- **SC-011** (Security): T232-T233, T044-T045, T097.1-T097.9 (Brakeman, Bundler-audit, CI, RLS)
- **SC-012** (Responsive design): T154 (viewport testing)
- **SC-013** (i18n verification): T017-T018, T234 (automated checks for all README pairs)
- **SC-014** (CI/CD checks): T044-T046, T243 (all workflows)
- **SC-015** (Package creation time): T058-T084 (streamlined process)
- **SC-016** (RLS data isolation): T097.1-T097.9, T166, T209, T226 (RLS infrastructure and tests)

---

## Notes

- [P] tasks = different files, no dependencies, can run in parallel
- [Story] label maps task to specific user story (US1-US6) for traceability
- Each user story is independently completable and testable
- Verify documentation line counts match after each README creation (including package READMEs)
- Commit after each logical group of tasks (e.g., after completing all migrations)
- Stop at any checkpoint to validate story independently
- Rails Engine structure allows future extraction of packages to separate gems/repositories
- Authentication implemented as auth-srv/auth-frt packages to match React repository structure
- Clusters implemented as clusters-srv/clusters-frt packages with full RLS support
- Testing infrastructure is set up but individual test writing happens during implementation
- All file paths assume Rails 7.0+ conventions with engines in packages/
- Tests not explicitly requested but testing infrastructure mandatory per constitution
- Bilingual documentation (EN/RU) is constitutional requirement with automated verification
- RLS (Row-Level Security) is mandatory for data isolation at database level

---

**Total Tasks**: 248  
**Parallelizable Tasks**: ~140 (56%)  
**Estimated MVP (US1-2)**: 84 tasks  
**Estimated Full Implementation**: All 248 tasks

**New in this revision**:
- Added Phase 5.5 for RLS setup (T097.1-T097.9)
- Refactored US4 (Auth) to create auth-srv and auth-frt packages (T098-T137)
- Added RLS migrations and tests to US6 (Clusters) (T166, T209, T226)
- Updated task numbering throughout (T138-T248)

**Format Validation**: ✅ All tasks follow format: `- [ ] [ID] [P?] [Story?] Description with file path`

---

## Future Package Roadmap

**Status**: Planning phase - these packages will be implemented in subsequent feature branches

**Reference**: Based on React repository structure at https://github.com/teknokomo/universo-platformo-react/tree/main/packages

### Package Categories Overview

The full Universo Platformo implementation consists of multiple package categories that build upon the foundational setup completed in Phases 1-9:

#### Category 1: Core Business Entities (After Phase 9)
- **Profile** (`profile-frt/srv`) - User profile management
- **Organizations** (`organizations-frt/srv`) - Organization/team management  
- **Uniks** (`uniks-frt/srv`) - Extended hierarchy for user workspaces
- **Metaverses** (`metaverses-frt/srv`) - Virtual world organizational units
- **Projects** (`projects-frt/srv`) - Project management within organizations

#### Category 2: Space & Content Creation
- **Spaces** (`spaces-frt/srv`) - 3D environment management
- **Space Builder** (`space-builder-frt/srv`) - Visual 3D space editor
- **Storages** (`storages-frt/srv`) - Asset storage and management

#### Category 3: Node-Based Systems (Most Complex)
- **Flowise Components** → **LangChain Nodes** (`langchain-nodes-srv`) - LangChain operation nodes
- **UPDL** (`updl/base`) - Universal Platform Description Language nodes
- **Flowise Server** → **Node Execution Engine** (`node-engine-srv`) - Node graph execution
- **Flowise UI** → **Node Canvas** (`node-canvas-frt`) - Visual node graph editor

#### Category 4: Publishing & Deployment  
- **Publish** (`publish-frt/srv`) - Content publishing and deployment system

#### Category 5: Analytics & Monitoring
- **Analytics** (`analytics-frt`) - Analytics dashboards and reporting

#### Category 6: Advanced Features
- **Multiplayer** (`multiplayer-srv`) - Real-time multiplayer via ActionCable (not Colyseus)
- **Templates** (`template-*`) - Pre-built application templates

### Implementation Priority Order

**Phase 10-15: Core Business Entities** (Next priority after initial setup)
- Phase 10: Profile Package
- Phase 11: Organizations Package  
- Phase 12: Metaverses Package
- Phase 13: Uniks Package
- Phase 14: Projects Package

**Phase 16-19: Space & Content**
- Phase 16: Spaces Package
- Phase 17: Space Builder Package  
- Phase 18: Storages Package

**Phase 20-24: Node-Based Systems** (Most complex, requires all previous)
- Phase 20: Node System Architecture Planning
- Phase 21: LangChain Nodes Package
- Phase 22: UPDL Nodes Package  
- Phase 23: Node Execution Engine
- Phase 24: Node Canvas UI

**Phase 25-27: Publishing & Analytics**
- Phase 25: Publish Package
- Phase 26: Analytics Package

**Phase 28+: Advanced Features**
- Phase 28: Multiplayer Package
- Phase 29+: Template Packages

### Key Architectural Principles for Future Packages

1. **Avoid Flowise Legacy Code**: The React repo contains monolithic Flowise packages that should NOT be ported as-is. Instead:
   - Break Flowise components into smaller, focused packages
   - Separate LangChain-specific nodes from UPDL nodes
   - Create clean Rails engine structure for each node type
   
2. **Frontend/Backend Separation**: Each package should have:
   - `-srv` package for backend logic (Rails Engine)
   - `-frt` package for frontend components (ViewComponents + Stimulus)
   
3. **Package Independence**: Each package should be:
   - Independently deployable as a gem
   - Testable in isolation
   - Documented with bilingual README (EN/RU)
   
4. **Incremental Delivery**: After Phase 9 (Clusters complete):
   - Each subsequent phase delivers a complete, working feature
   - Phases can be prioritized based on business needs
   - Early phases (10-15) provide immediate business value
   - Later phases (20-24) enable advanced node-based programming

### Node System Architecture Notes

The node-based system (Phases 20-24) is the most complex part of the platform and requires special planning:

**Current State in React Repo (Legacy)**:
- `flowise-components`: Monolithic package with all node types mixed together
- `flowise-server`: Complex server with node execution, storage, and API
- `flowise-ui`: Large UI package with node editor and many other features

**Planned Ruby Architecture (Clean Separation)**:
- `langchain-nodes-srv`: LangChain-specific nodes (Chat Models, Chains, Agents, Tools, etc.)
- `updl-nodes-srv`: UPDL custom nodes for platform-specific operations  
- `node-engine-srv`: Generic node graph execution engine (language-agnostic)
- `node-canvas-frt`: Visual node graph editor UI (ViewComponent + Stimulus + Canvas API)
- `node-types`: Shared type definitions and interfaces for all node systems

**Why This Structure is Better**:
1. **Clear separation of concerns**: LangChain nodes don't mix with UPDL nodes
2. **Reusability**: Node execution engine can run any node type
3. **Testing**: Each node type package can be tested independently
4. **Deployment**: Can deploy LangChain nodes without UPDL or vice versa
5. **Maintainability**: Smaller packages are easier to understand and modify

### Feature Parity vs Code Parity Reminder

As documented in plan.md and research.md:

- ✅ **Goal**: Feature parity with React implementation
- ❌ **NOT Goal**: Code parity or direct translation

**This means**:
- Same user-facing functionality and features
- Different implementation using Rails best practices
- Cleaner architecture than current React structure
- No porting of Flowise legacy patterns
- Rails-idiomatic solutions over React patterns

### Creating New Feature Branches

When ready to implement phases beyond Phase 9:

1. **Review React implementation** for feature understanding (not code copying)
2. **Create new feature spec** using `/speckit.specify` command
3. **Generate implementation plan** using `/speckit.plan` command  
4. **Generate tasks** using `/speckit.tasks` command
5. **Implement following Rails conventions** and package patterns from Clusters
6. **Test independently** before integration
7. **Update FEATURE_PARITY.md** to track implementation status

### References

- **React Repository**: https://github.com/teknokomo/universo-platformo-react
- **React Packages**: https://github.com/teknokomo/universo-platformo-react/tree/main/packages  
- **Flowise Components**: https://github.com/teknokomo/universo-platformo-react/tree/main/packages/flowise-components
- **UPDL Package**: https://github.com/teknokomo/universo-platformo-react/tree/main/packages/updl

---

**Roadmap Status**: ✅ Documented and prioritized  
**Next Phase After Phase 9**: Phase 10 - Profile Package  
**Total Estimated Phases**: 29+ phases covering all functionality
