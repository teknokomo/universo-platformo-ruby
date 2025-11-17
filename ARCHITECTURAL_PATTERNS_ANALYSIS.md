# Architectural Patterns Analysis: React vs Ruby Implementation

**Date**: 2025-11-17  
**Purpose**: Deep analysis of React repository to identify architectural patterns not yet captured in Ruby implementation plans  
**React Source**: https://github.com/teknokomo/universo-platformo-react  
**Ruby Target**: https://github.com/teknokomo/universo-platformo-ruby

---

## Executive Summary

This document presents findings from a thorough analysis of the React implementation to ensure all best architectural patterns and concepts are captured in the Ruby implementation plans. Analysis covers 37 packages from the React repository.

**Key Findings**:
- ✅ Core architecture patterns ALREADY captured in current plans
- 🔍 Additional patterns identified requiring plan updates
- ⚠️ Legacy Flowise patterns explicitly identified to AVOID
- 📋 New requirements discovered for enhanced implementation

---

## 1. Monorepo Architecture Patterns

### React Implementation (PNPM Workspace + Turbo)

**Structure**:
```yaml
# pnpm-workspace.yaml
packages:
  - 'packages/*'
  - 'packages/*/base'

# turbo.json - Build orchestration
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", "build/**"],
      "cache": false
    },
    "dev": { "cache": false, "persistent": true },
    "test": {},
    "clean": { "cache": false }
  }
}
```

**Package Structure Pattern**:
```
packages/
├── feature-name-srv/
│   └── base/              # Core implementation
│       ├── src/
│       ├── package.json
│       ├── tsconfig.json
│       └── tsdown.config.ts
├── feature-name-frt/
│   └── base/
```

### Ruby Implementation Adaptation

**Current Plan Status**: ✅ ADEQUATELY COVERED

The constitution and spec already specify:
- Rails Engines for package management
- `packages/` directory with `-frt`/`-srv` suffixes
- `base/` subdirectories for future implementations
- Bundler for dependency management

**Recommended Enhancement**: 📋 ADD BUILD ORCHESTRATION

While the basic structure is captured, the React version uses Turbo for build orchestration with dependency management. Ruby equivalent would be:

```ruby
# Add to constitution or plan
- Use Rake tasks for build orchestration
- Document package build dependencies
- Create tasks for parallel package testing
```

**Action**: Add build orchestration documentation to DEVELOPMENT.md

---

## 2. Row-Level Security (RLS) Pattern

### React Implementation

**Critical Pattern Discovered**: The React implementation has a sophisticated **Row-Level Security (RLS)** pattern for PostgreSQL that propagates JWT context to database queries.

**Implementation**:
```typescript
// auth-srv/base/src/middlewares/ensureAuthWithRls.ts
export interface RequestWithDbContext extends AuthenticatedRequest {
    dbContext?: {
        queryRunner: QueryRunner
        manager: EntityManager
    }
}

// Creates QueryRunner per request
// Sets PostgreSQL session variables from JWT
// Enables RLS policies at database level
```

**Key Features**:
- Per-request QueryRunner for RLS isolation
- JWT token propagation to PostgreSQL session
- Automatic cleanup on request completion
- Enables database-level authorization policies

### Ruby Implementation Gap

**Current Plan Status**: ⚠️ NOT ADEQUATELY COVERED

The current plan mentions authorization guards at controller level but does NOT mention database-level RLS.

**Recommended Addition**: 📋 CRITICAL SECURITY PATTERN

Add to specifications:

```markdown
### Row-Level Security (RLS) Integration

**FR-XXX**: System MUST support PostgreSQL Row-Level Security (RLS) policies
**FR-XXX**: System MUST propagate authentication context to database session
**FR-XXX**: System MUST use per-request database connections for RLS isolation
**FR-XXX**: System MUST configure Supabase RLS policies for all user-owned entities

**Implementation Pattern**:
```ruby
# Use ActiveRecord connection pooling with session variables
# Middleware to set PostgreSQL session variables from JWT
# Example: SET LOCAL request.jwt.claims TO '{"sub":"user-id"}'

class RlsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    if request.session[:jwt_token]
      # Decode JWT and set session variables
      ActiveRecord::Base.connection.execute(
        "SET LOCAL request.jwt.claims = '#{jwt_claims_json}'"
      )
    end
    @app.call(env)
  end
end
```

**Rationale**: Database-level RLS provides defense-in-depth security, preventing data leaks even if application-level authorization fails.

**Action**: Add RLS requirements to spec.md FR section

---

## 3. Shared Package Architecture

### React Implementation

**Packages Identified**:
```
universo-types/         # Core types and Zod schemas
universo-utils/         # Utility functions (api, math, net, serialization, validation)
universo-api-client/    # Standardized HTTP client
universo-i18n/          # Internationalization extensions
universo-template-mui/  # Shared UI component library
universo-rest-docs/     # API documentation
```

**universo-types Structure**:
```typescript
// Domain-driven type organization
export * from './ecs'           // Entity Component System types
export * from './protocol'      // Communication protocols
export * from './geometry'      // 3D geometry types
export * from './validation'    // Zod schemas
```

**universo-utils Structure**:
```
src/
├── api/              # HTTP client utilities
├── delta/            # Delta compression
├── env/              # Environment detection
├── math/             # Math utilities
├── net/              # Network utilities
├── publish/          # Publishing utilities
├── rate-limiting/    # Rate limit helpers
├── serialization/    # Data serialization
├── ui-utils/         # UI helpers
├── updl/             # UPDL utilities
└── validation/       # Validation helpers
```

### Ruby Implementation Gap

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions creating universo-types, universo-utils, and universo-template packages but doesn't provide detailed organization.

**Recommended Enhancement**: 📋 DETAILED SHARED PACKAGE ARCHITECTURE

Add to spec.md:

```markdown
### Shared Package Organization

**universo-types Package** (`packages/universo-types/base/`):
- Entity schemas with ActiveModel validations
- Concern modules for shared behavior
- Custom types and value objects
- JSON schemas for API validation

**universo-utils Package** (`packages/universo-utils/base/`):
- API client helpers (HTTP, error handling)
- Math utilities (vector operations, transformations)
- Serialization helpers (JSON, MessagePack)
- Validation utilities (custom validators)
- Rate limiting helpers
- Environment detection

**universo-template Package** (`packages/universo-template/base/`):
- Shared ViewComponent library
- Stimulus controllers for common behaviors
- Tailwind component styles
- Hotwire Turbo Frame patterns

**universo-i18n Package** (`packages/universo-i18n/base/`):
- I18n helper methods
- Translation management tools
- Locale switching utilities
- Pluralization rules

**Creation Priority**:
1. universo-types (needed immediately for Clusters)
2. universo-utils (needed for API clients)
3. universo-template (needed for UI consistency)
4. universo-i18n (can be deferred if only EN/RU)
```

**Action**: Expand shared package documentation in spec.md

---

## 4. Testing Patterns

### React Implementation

**Testing Stack**:
```json
{
  "vitest": "^2.1.8",           // Test runner
  "@testing-library/react": "^14.3.1",
  "@testing-library/jest-dom": "^6.8.0",
  "happy-dom": "^16.14.2"       // DOM simulation
}
```

**Test Organization Pattern**:
```
packages/clusters-srv/base/
├── src/
│   ├── tests/
│   │   ├── utils/
│   │   │   └── typeormMocks.ts    # Database mocking
│   │   └── routes/
│   │       └── clustersRoutes.test.ts
│   ├── database/
│   └── routes/
```

**Key Testing Patterns**:
1. **TypeORM Mocking**: Mock database for unit tests
2. **Route Testing**: Test Express routes independently
3. **Happy-DOM**: Lightweight DOM for React component tests
4. **Integration Tests**: Full request/response cycle

### Ruby Implementation

**Current Plan Status**: ✅ ADEQUATELY COVERED

The spec already specifies:
- RSpec for testing
- FactoryBot for fixtures
- Capybara for integration
- Minimum 80% coverage

**Recommended Enhancement**: 📋 TEST ORGANIZATION DETAILS

Add to spec.md:

```markdown
### Test Organization Standards

**Directory Structure**:
```ruby
spec/
├── models/
│   └── clusters/
│       ├── cluster_spec.rb
│       ├── domain_spec.rb
│       └── resource_spec.rb
├── controllers/
│   └── clusters/
│       └── clusters_controller_spec.rb
├── requests/              # API integration tests
│   └── clusters_api_spec.rb
├── features/              # Capybara feature tests
│   └── cluster_management_spec.rb
├── factories/
│   └── clusters/
│       ├── clusters.rb
│       ├── domains.rb
│       └── resources.rb
└── support/
    ├── database_helpers.rb
    ├── auth_helpers.rb
    └── api_helpers.rb
```

**Test Naming Pattern**:
- Model tests: `{model_name}_spec.rb`
- Controller tests: `{controller_name}_spec.rb`
- Request tests: `{resource}_api_spec.rb`
- Feature tests: `{feature_name}_spec.rb`

**Mock Strategy**:
- Mock external services (Supabase Auth API calls)
- Use real database with test fixtures (not in-memory)
- VCR for recording HTTP interactions
```

**Action**: Add test organization section to spec.md

---

## 5. API Design Patterns

### React Implementation

**Route Pattern**:
```typescript
// clusters-srv/base/src/routes/clustersRoutes.ts

// CRUD endpoints
GET    /clusters
POST   /clusters
GET    /clusters/:id
PUT    /clusters/:id
DELETE /clusters/:id

// Relationship management (idempotent)
POST   /clusters/:id/domains/:domain_id      # Add domain
DELETE /clusters/:id/domains/:domain_id      # Remove domain
GET    /clusters/:id/domains                 # List domains
GET    /clusters/:id/resources               # List all resources in hierarchy

// Member management with roles
GET    /clusters/:id/members                 # List members
POST   /clusters/:id/members                 # Add member
DELETE /clusters/:id/members/:user_id        # Remove member
PUT    /clusters/:id/members/:user_id        # Update role/comment
```

**Key API Patterns**:
1. **Idempotent Operations**: Adding same domain multiple times doesn't error
2. **Role-Based Access**: Owner/admin/member roles with different permissions
3. **Pagination & Sorting**: Query params for list endpoints
4. **Search**: Cross-entity search (by email, nickname, etc.)
5. **Aggregations**: Count of related entities in list responses

**Query Parameters**:
```typescript
// Validated with Zod schemas
interface ListQuery {
  limit?: number      // Default 100, max 100
  offset?: number     // Default 0
  sortBy?: string     // 'created', 'updated', 'name'
  sortOrder?: 'asc' | 'desc'
  search?: string     // Full-text search
}
```

**Error Response Format**:
```typescript
{
  success: false,
  error: 'Error message',
  errors?: string[],           // Multiple errors
  field_errors?: {             // Field-specific errors
    name: ['Name is required'],
    email: ['Invalid email format']
  }
}
```

### Ruby Implementation

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions RESTful endpoints and idempotent operations but lacks detail on:
- Member management endpoints
- Role-based authorization
- Query parameter standards
- Error response format

**Recommended Enhancement**: 📋 COMPREHENSIVE API STANDARDS

Add to spec.md:

```markdown
### API Endpoint Standards

**Base CRUD Pattern**:
```ruby
# config/routes.rb
namespace :clusters do
  resources :clusters do
    # Relationship management
    member do
      scope module: 'relationships' do
        post   'domains/:domain_id',   to: 'domains#create'
        delete 'domains/:domain_id',   to: 'domains#destroy'
        get    'domains',              to: 'domains#index'
        get    'resources',            to: 'resources#index'
      end
      
      # Member management
      scope module: 'members' do
        get    'members',              to: 'members#index'
        post   'members',              to: 'members#create'
        delete 'members/:user_id',     to: 'members#destroy'
        patch  'members/:user_id',     to: 'members#update'
      end
    end
  end
end
```

**Query Parameter Standards**:
```ruby
# FR-XXX: All list endpoints MUST support pagination
# FR-XXX: All list endpoints MUST support sorting
# FR-XXX: All list endpoints MUST support search where applicable

# app/controllers/concerns/paginatable.rb
module Paginatable
  extend ActiveSupport::Concern
  
  included do
    before_action :set_pagination_params, only: [:index]
  end
  
  private
  
  def set_pagination_params
    @page = params[:page]&.to_i || 1
    @per_page = [[params[:per_page]&.to_i || 25, 100].min, 1].max
    @sort_by = params[:sort_by] || 'created_at'
    @sort_order = %w[asc desc].include?(params[:sort_order]) ? params[:sort_order] : 'desc'
    @search = params[:search]
  end
end
```

**Error Response Standards**:
```ruby
# app/controllers/concerns/api_error_handler.rb
module ApiErrorHandler
  extend ActiveSupport::Concern
  
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end
  
  private
  
  def render_error(message, status: :unprocessable_entity, errors: nil, field_errors: nil)
    render json: {
      success: false,
      error: message,
      errors: errors,
      field_errors: field_errors
    }, status: status
  end
  
  def unprocessable_entity(exception)
    record = exception.record
    render_error(
      'Validation failed',
      status: :unprocessable_entity,
      errors: record.errors.full_messages,
      field_errors: record.errors.messages
    )
  end
end
```

**Member Management Requirements**:
```markdown
**FR-XXX**: System MUST support role-based member management (owner, admin, member)
**FR-XXX**: System MUST enforce role permissions (only owners can delete entity, admins can manage members)
**FR-XXX**: System MUST prevent self-removal of last owner
**FR-XXX**: System MUST allow member role updates by admins and owners
**FR-XXX**: System MUST support member comments/notes
```

**Action**: Add comprehensive API standards to spec.md

---

## 6. File Naming Conventions

### React Implementation

The React repository has a detailed FILE_NAMING.md document specifying:

**React/TypeScript Conventions**:
- **PascalCase**: React components and files with JSX
- **camelCase**: Utilities, hooks, pure TS/JS modules
- **kebab-case**: All directories

**Decision Tree**:
```
Contains JSX? 
├─ YES → PascalCase (MetaverseList.tsx)
└─ NO → Is React component?
    ├─ YES → PascalCase
    └─ NO → camelCase (apiClient.ts)
```

### Ruby Implementation

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions some conventions but lacks comprehensive file naming guide.

**Recommended Enhancement**: 📋 COMPREHENSIVE FILE NAMING GUIDE

Add to spec.md and create `.github/FILE_NAMING.md`:

```markdown
# Ruby on Rails File Naming Conventions

## Rails Conventions (MANDATORY)

**Models**: `app/models/clusters/cluster.rb` (singular, snake_case)
**Controllers**: `app/controllers/clusters/clusters_controller.rb` (plural, snake_case, _controller suffix)
**Views**: `app/views/clusters/clusters/index.html.erb` (matches controller)
**Helpers**: `app/helpers/clusters/clusters_helper.rb` (plural, snake_case, _helper suffix)
**Services**: `app/services/clusters/cluster_creator.rb` (singular, snake_case, descriptive name)
**Concerns**: `app/controllers/concerns/paginatable.rb` (adjective, snake_case)
**Components**: `app/components/clusters/cluster_card_component.rb` (singular, snake_case, _component suffix)
**Specs**: `spec/models/clusters/cluster_spec.rb` (matches file being tested, _spec suffix)
**Factories**: `spec/factories/clusters/clusters.rb` (plural, snake_case)
**Migrations**: `db/migrate/20250117120000_create_clusters_clusters.rb` (timestamp, verb_table)

## Package Conventions

**Directories**: `kebab-case` (e.g., `clusters-srv/`, `space-builder-frt/`)
**Namespace Modules**: `lib/clusters.rb` (snake_case, matches package)
**Engine Files**: `lib/clusters/engine.rb` (snake_case)

## JavaScript/Stimulus Conventions (Frontend)

**Stimulus Controllers**: `app/javascript/clusters/controllers/list_controller.js` (snake_case, _controller suffix)
**Utilities**: `app/javascript/clusters/utils/api_client.js` (snake_case)

## Decision Tree

```
Is it a Ruby file?
├─ Model? → singular snake_case
├─ Controller? → plural snake_case + _controller.rb
├─ View? → matches controller path
├─ Service? → descriptive snake_case
├─ Component? → singular snake_case + _component.rb
└─ Spec? → matches tested file + _spec.rb

Is it a directory?
└─ kebab-case

Is it a JavaScript file?
├─ Controller? → snake_case + _controller.js
└─ Utility? → snake_case.js
```
```

**Action**: Create .github/FILE_NAMING.md with Rails conventions

---

## 7. CI/CD Workflow Patterns

### React Implementation

**Workflows Identified**:
```yaml
# .github/workflows/
- docs-i18n-check.yml          # Verify bilingual docs line count
- main.yml                      # Main CI/CD (tests, build)
- docker-image.yml              # Docker build and push
- test_docker_build.yml         # Test Docker build
- autoSyncMergedPullRequest.yml # Auto-sync to private repo
- autoSyncSingleCommit.yml      # Auto-sync commits
```

**docs-i18n-check.yml Pattern**:
```yaml
# Validates that bilingual documentation has matching line counts
- name: Check Documentation Line Counts
  run: node tools/docs/check-i18n-docs.mjs
```

### Ruby Implementation

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions CI/CD but doesn't specify bilingual documentation verification workflow.

**Recommended Enhancement**: 📋 BILINGUAL DOCS VERIFICATION

Add to spec.md:

```markdown
**FR-XXX**: System MUST include automated verification of bilingual documentation line counts
**FR-XXX**: System MUST fail CI/CD if English and Russian docs have different line counts
**FR-XXX**: System MUST run documentation checks on every pull request

Create `.github/workflows/docs-i18n-check.yml`:
```yaml
name: Verify Bilingual Documentation

on:
  pull_request:
    paths:
      - '**/*.md'
      - '**/*-RU.md'

jobs:
  check-i18n-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check line counts
        run: |
          ruby tools/check_i18n_docs.rb
```

Create `tools/check_i18n_docs.rb`:
```ruby
#!/usr/bin/env ruby

errors = []

Dir.glob('**/*.md').each do |en_file|
  next if en_file.end_with?('-RU.md')
  ru_file = en_file.sub(/\.md$/, '-RU.md')
  
  if File.exist?(ru_file)
    en_lines = File.readlines(en_file).count
    ru_lines = File.readlines(ru_file).count
    
    if en_lines != ru_lines
      errors << "#{en_file}: #{en_lines} lines, #{ru_file}: #{ru_lines} lines"
    end
  end
end

if errors.any?
  puts "❌ Bilingual documentation line count mismatch:"
  errors.each { |e| puts "  - #{e}" }
  exit 1
else
  puts "✅ All bilingual documentation line counts match"
end
```
```

**Action**: Add bilingual docs verification workflow

---

## 8. Authentication Patterns

### React Implementation

**Auth Stack**:
```typescript
// auth-srv package
- Passport.js with Supabase strategy
- Session management with Supabase tokens
- JWT token propagation to database (RLS)
- Role-based permissions system
```

**Key Files**:
```
auth-srv/base/src/
├── passport/index.ts              # Passport configuration
├── services/supabaseSession.ts    # Session management
├── middlewares/
│   ├── ensureAuth.ts              # Basic auth check
│   └── ensureAuthWithRls.ts       # Auth + RLS context
├── guards/
│   ├── createAccessGuards.ts      # Factory for auth guards
│   └── types.ts                   # Guard type definitions
└── utils/rlsContext.ts            # RLS context utilities
```

**Permission System**:
```typescript
const ROLE_PERMISSIONS = {
  owner: {
    canView: true,
    canEdit: true,
    canDelete: true,
    canManageMembers: true,
    canChangeOwner: true
  },
  admin: {
    canView: true,
    canEdit: true,
    canDelete: false,
    canManageMembers: true,
    canChangeOwner: false
  },
  member: {
    canView: true,
    canEdit: false,
    canDelete: false,
    canManageMembers: false,
    canChangeOwner: false
  }
}
```

### Ruby Implementation

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions Supabase Auth and Devise but doesn't detail role-based permissions.

**Recommended Enhancement**: 📋 ROLE-BASED PERMISSION SYSTEM

Add to spec.md:

```markdown
### Role-Based Authorization System

**FR-XXX**: System MUST implement three-tier role system: owner, admin, member
**FR-XXX**: System MUST enforce role permissions at controller level
**FR-XXX**: System MUST prevent privilege escalation (members can't become admins without owner/admin approval)
**FR-XXX**: System MUST preserve at least one owner per entity (can't remove last owner)
**FR-XXX**: System MUST support role-based method authorization

**Implementation**:
```ruby
# app/models/concerns/role_based_access.rb
module RoleBasedAccess
  extend ActiveSupport::Concern
  
  ROLE_PERMISSIONS = {
    owner: {
      can_view: true,
      can_edit: true,
      can_delete: true,
      can_manage_members: true,
      can_change_owner: true
    },
    admin: {
      can_view: true,
      can_edit: true,
      can_delete: false,
      can_manage_members: true,
      can_change_owner: false
    },
    member: {
      can_view: true,
      can_edit: false,
      can_delete: false,
      can_manage_members: false,
      can_change_owner: false
    }
  }.freeze
  
  def can?(user, action)
    membership = members.find_by(user: user)
    return false unless membership
    
    permissions = ROLE_PERMISSIONS[membership.role.to_sym]
    permissions["can_#{action}".to_sym] == true
  end
end

# app/controllers/concerns/authorization.rb
module Authorization
  extend ActiveSupport::Concern
  
  private
  
  def authorize_action!(resource, action)
    unless resource.can?(current_user, action)
      render json: {
        success: false,
        error: "You don't have permission to #{action} this resource"
      }, status: :forbidden
    end
  end
end
```
```

**Action**: Add role-based authorization requirements to spec.md

---

## 9. Legacy Code Identification

### Flowise Legacy Patterns to AVOID

**Identified Legacy Packages** (from React repo):
```
❌ flowise-chatmessage     # Original Flowise chat UI
❌ flowise-components      # Original Flowise components
❌ flowise-server          # Original Flowise server
❌ flowise-store           # Original Flowise state management
❌ flowise-template-mui    # Original Flowise MUI template
❌ flowise-ui              # Original Flowise UI
```

**How to Identify Legacy**:
1. Check git history - files predating "Universo Platformo"
2. Look for TODO comments mentioning "Flowise" or "refactor"
3. Compare newer packages (clusters, metaverses) with older code
4. Check for inconsistent patterns vs newer packages

**Legacy Patterns to AVOID**:
- Hard-coded configurations (use env vars)
- Monolithic controllers (use service objects)
- Missing tests (maintain 80% coverage)
- Inconsistent naming (follow conventions)
- Direct database queries in controllers (use models/services)

### Ruby Implementation

**Current Plan Status**: ✅ ADEQUATELY COVERED

The constitution explicitly excludes:
- Flowise legacy code
- React implementation flaws
- Unrefactored patterns

**No Action Required**: Already covered

---

## 10. Package Template Patterns

### React Implementation

**Package README Template**:
```markdown
# @universo/{package-name}

## Overview
Brief description of package purpose and functionality.

## Installation
```bash
pnpm install
pnpm build
```

## Usage
Example code showing how to use the package.

## API Reference
Detailed API documentation.

## Development
How to develop and test the package.

## License
Omsk Open License
```

**Package.json Template**:
```json
{
  "name": "@universo/package-name",
  "version": "0.1.0",
  "description": "Package description",
  "private": true,
  "main": "dist/index.js",
  "module": "dist/index.mjs",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.mjs",
      "require": "./dist/index.js"
    }
  },
  "scripts": {
    "clean": "rimraf dist",
    "build": "tsdown",
    "dev": "tsdown --watch",
    "test": "vitest run"
  }
}
```

### Ruby Implementation

**Current Plan Status**: ⚠️ PARTIALLY COVERED

The spec mentions package READMEs but doesn't provide detailed template.

**Recommended Enhancement**: 📋 PACKAGE TEMPLATES

Create `packages/PACKAGE_TEMPLATE_README.md`:
```markdown
# Clusters Package (clusters-srv)

**Version**: 0.1.0  
**Status**: Active Development  
**Architecture**: Rails Engine (Modular Package)

## Overview

The Clusters package provides three-entity hierarchy management (Cluster → Domain → Resource) with role-based access control and complete data isolation.

## Key Features

- **Three-Entity Hierarchy**: Cluster → Domain → Resource
- **Role-Based Access**: Owner/Admin/Member permissions
- **Data Isolation**: Complete user-level data separation
- **RESTful API**: Standard REST endpoints + relationship management
- **Database Integration**: PostgreSQL via Supabase with RLS

## Installation

Add to main application Gemfile:
```ruby
gem 'clusters', path: 'packages/clusters-srv/base'
```

Then run:
```bash
bundle install
rails clusters:install:migrations
rails db:migrate
```

## Usage

Mount engine in main application routes:
```ruby
# config/routes.rb
mount Clusters::Engine, at: '/clusters'
```

Basic usage:
```ruby
# Create cluster
cluster = Clusters::Cluster.create!(name: 'My Cluster')
cluster.users << current_user

# Add domain
domain = Clusters::Domain.create!(name: 'My Domain')
cluster.domains << domain

# Add resource
resource = Clusters::Resource.create!(name: 'My Resource')
domain.resources << resource
```

## API Reference

See [API.md](./API.md) for detailed endpoint documentation.

## Architecture

### Entity Relationships
```
Cluster (1) ──< DomainCluster >── (N) Domain
Domain (1)  ──< ResourceDomain >── (N) Resource
Cluster (1) ──< ClusterUser >──── (N) User
```

### Key Design Decisions

- **Junction Tables**: Many-to-many relationships for flexibility
- **Cascade Deletion**: Database-level CASCADE for referential integrity
- **Idempotent Operations**: Re-adding same relationship doesn't error
- **Role-Based Security**: Enforced at controller and database level

## Testing

Run package tests:
```bash
cd packages/clusters-srv/base
bundle exec rspec
```

Coverage requirement: 80% minimum

## Contributing

Follow project guidelines in [CONTRIBUTING.md](../../../CONTRIBUTING.md).

## License

Omsk Open License
```

**Action**: Create package template documentation

---

## Summary of Required Updates

### 1. Constitution Updates

**No changes required** - current constitution adequately covers principles.

### 2. Specification Updates (spec.md)

Add the following sections:

#### New Functional Requirements:
- **FR-087 to FR-095**: Row-Level Security (RLS) requirements
- **FR-096 to FR-105**: Role-based authorization system
- **FR-106 to FR-115**: Member management endpoints
- **FR-116 to FR-125**: Query parameter standards
- **FR-126 to FR-135**: Error response standards
- **FR-136 to FR-145**: Bilingual documentation verification

#### New Sections:
- **Shared Package Architecture**: Detailed organization of universo-* packages
- **Role-Based Permission System**: Three-tier role model
- **API Standards**: Comprehensive API design patterns
- **Test Organization Standards**: Detailed test structure

### 3. Plan Updates (plan.md)

Add technical context for:
- Row-Level Security integration approach
- Role-based authorization implementation
- Build orchestration strategy

### 4. Research Updates (research.md)

Add research tasks for:
- PostgreSQL RLS with ActiveRecord
- JWT propagation to database session
- Role-based authorization gems (Pundit vs CanCanCan)
- Build orchestration tools for monorepo

### 5. New Files to Create

- `.github/FILE_NAMING.md` - Rails file naming conventions
- `.github/workflows/docs-i18n-check.yml` - Bilingual docs verification
- `tools/check_i18n_docs.rb` - Line count verification script
- `packages/PACKAGE_TEMPLATE_README.md` - Package README template

### 6. Data Model Updates (data-model.md)

Add entities:
- `ClusterMember` with role and permissions
- Detail RLS policy structure
- Expand junction table documentation

### 7. Contracts Updates (contracts/)

Add API contracts for:
- Member management endpoints
- Role-based operations
- Query parameters schema
- Error response schema

---

## Prioritization

### High Priority (Must implement before Clusters package)
1. ✅ Row-Level Security requirements
2. ✅ Role-based authorization system
3. ✅ API standards (error format, pagination)
4. ✅ Bilingual documentation verification

### Medium Priority (Implement with Clusters package)
1. Member management system
2. Shared packages (universo-types, universo-utils)
3. Test organization standards
4. Package template documentation

### Low Priority (Can defer to later iterations)
1. Build orchestration documentation
2. Advanced query patterns
3. Additional CI/CD workflows
4. Performance optimization patterns

---

## Validation Checklist

Before updating specifications:

- [ ] Verify all patterns align with Rails best practices
- [ ] Ensure no React-specific anti-patterns are included
- [ ] Confirm exclusions are maintained (docs/, Flowise legacy)
- [ ] Validate bilingual documentation requirements
- [ ] Check constitutional compliance
- [ ] Verify patterns don't conflict with Rails conventions

---

**Status**: Analysis Complete - Ready for Specification Updates  
**Next Steps**: Update specification documents with findings  
**Estimated Impact**: 50+ new functional requirements, 5 new files, enhanced documentation
