# Phase 0: Research & Technical Decisions

**Feature**: Initial Platform Setup for Ruby Implementation  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This document consolidates research findings and technical decisions for implementing Universo Platformo Ruby using Rails best practices while maintaining feature parity with the React reference implementation.

---

## Research Areas

### 1. Rails Engines for Monorepo Package Management

**Decision**: Use Rails Engines with mountable configuration

**Rationale**:
- Rails Engines provide true isolation with separate namespaces
- Support independent testing and potential gem extraction
- Native Rails solution (no third-party dependencies)
- Engines can be mounted at specific routes in main application
- Each engine has its own routes, controllers, models, views
- Bundler manages dependencies between engines efficiently

**Alternatives Considered**:
- **Plain Ruby gems**: Less Rails integration, more boilerplate
- **Rails Concerns only**: Insufficient isolation between packages
- **Separate repositories**: Loses monorepo benefits (unified testing, atomic changes)

**Implementation Pattern**:
```ruby
# Generate mountable engine
rails plugin new packages/clusters-srv/base --mountable --skip-test

# In main app Gemfile
gem 'clusters', path: 'packages/clusters-srv/base'

# Mount in config/routes.rb
mount Clusters::Engine => '/clusters'
```

**Best Practices**:
- Use `--mountable` flag for complete isolation
- Namespace all models, controllers, views under engine name
- Keep engines focused on single feature domain
- Share code via separate utility engines (universo-utils, universo-types)

---

### 2. Supabase Integration with Rails

**Decision**: Use `supabase-rb` gem + custom authentication layer

**Rationale**:
- Supabase provides PostgreSQL database with built-in Auth
- Official Ruby client exists: `supabase-rb` gem
- Can use standard Rails database.yml with PostgreSQL connection string
- Supabase Auth integrates via JWT tokens
- Real-time subscriptions available through PostgREST

**Alternatives Considered**:
- **Direct PostgreSQL without Supabase**: Loses Auth and real-time features
- **Devise + custom JWT**: More complex, reinvents Supabase Auth wheel
- **Auth0/Clerk**: Additional cost, less PostgreSQL integration

**Implementation Pattern**:
```ruby
# config/initializers/supabase.rb
require 'supabase'

SUPABASE_CLIENT = Supabase::Client.new(
  ENV['SUPABASE_URL'],
  ENV['SUPABASE_KEY']
)

# Database connection via standard Rails
# config/database.yml uses DATABASE_URL env var pointing to Supabase PostgreSQL
```

**Authentication Flow**:
1. Frontend sends credentials to Supabase Auth API
2. Supabase returns JWT token
3. Rails middleware validates JWT on protected endpoints
4. User session stored in Rails encrypted cookies or JWT payload

**Best Practices**:
- Store Supabase credentials in encrypted credentials file or env vars
- Create database abstraction layer in case of future migration
- Use connection pooling (Rails default)
- Implement JWT validation middleware for API endpoints

---

### 3. Hotwire (Turbo + Stimulus) for Reactive Frontend

**Decision**: Use Hotwire as primary frontend framework

**Rationale**:
- Native Rails 7 solution (included by default)
- Turbo provides SPA-like navigation without JavaScript frameworks
- Stimulus adds JavaScript behaviors where needed
- Server-side rendering (SEO-friendly, simpler state management)
- Excellent for CRUD applications like Clusters functionality
- Reduces JavaScript complexity compared to React approach

**Alternatives Considered**:
- **React**: Not suitable for Rails-first approach, adds complexity
- **Vue.js**: Requires separate build pipeline, less Rails integration
- **jQuery**: Outdated, poor structure for modern applications

**Turbo Features Used**:
- **Turbo Drive**: Intercepts links/forms for fast page transitions
- **Turbo Frames**: Scoped updates (e.g., update cluster list without full page reload)
- **Turbo Streams**: Real-time updates via WebSockets/SSE

**Stimulus Features Used**:
- Controllers for interactive behaviors (form validation, dynamic fields)
- Actions to respond to user events
- Targets to reference DOM elements

**Implementation Pattern**:
```erb
<!-- Turbo Frame for scoped updates -->
<%= turbo_frame_tag "cluster_list" do %>
  <%= render @clusters %>
<% end %>

<!-- Stimulus controller for dynamic behavior -->
<div data-controller="cluster-form">
  <%= form_with model: @cluster, data: { action: "submit->cluster-form#validate" } do |f| %>
    <!-- form fields -->
  <% end %>
</div>
```

**Best Practices**:
- Keep Stimulus controllers small and focused
- Use Turbo for navigation, Stimulus for interactions
- Progressive enhancement (works without JavaScript)
- Avoid jQuery, use modern JavaScript

---

### 4. ViewComponent for Reusable UI Components

**Decision**: Use ViewComponent gem for UI component library

**Rationale**:
- Created by GitHub, mature and well-maintained
- Object-oriented components instead of partials
- Easier testing (unit test components in isolation)
- Performance benefits (faster than ERB partials)
- Good for building design system (universo-template package)
- Compatible with Tailwind CSS and Stimulus

**Alternatives Considered**:
- **Plain ERB partials**: Less testable, no encapsulation
- **Phlex**: Newer, less ecosystem support
- **Cells gem**: More complex, less active maintenance

**Implementation Pattern**:
```ruby
# app/components/clusters/card_component.rb
module Clusters
  class CardComponent < ViewComponent::Base
    def initialize(cluster:)
      @cluster = cluster
    end
  end
end

# app/components/clusters/card_component.html.erb
<div class="cluster-card" data-controller="cluster-card">
  <h3><%= @cluster.name %></h3>
  <p><%= @cluster.description %></p>
</div>

# Usage in views
<%= render Clusters::CardComponent.new(cluster: @cluster) %>
```

**Best Practices**:
- One component per file with matching template
- Test components with RSpec
- Use slots for flexible content areas
- Namespace components under package name

---

### 5. Tailwind CSS with Material Design Theme

**Decision**: Use Tailwind CSS v3 with custom Material Design configuration

**Rationale**:
- Utility-first CSS, no large component library overhead
- Highly customizable for Material Design tokens
- Good Rails integration via `tailwindcss-rails` gem
- Fast development with JIT mode
- Easy to maintain consistent design system
- Smaller bundle size than full Material UI

**Alternatives Considered**:
- **Material Components Web**: Large bundle, less customization
- **Bootstrap**: Different design language than Material
- **Plain CSS/Sass**: More maintenance, no utility system

**Material Design Implementation**:
- Configure Tailwind colors to match Material palette
- Use Material Design elevation (shadows) via Tailwind utilities
- Typography scale matching Material guidelines
- Component styles in ViewComponents

**Implementation Pattern**:
```javascript
// config/tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#e3f2fd',
          // ... Material Blue palette
          900: '#0d47a1',
        },
        // ... other Material colors
      },
      boxShadow: {
        'md-1': '0 1px 3px rgba(0,0,0,0.12)', // Material elevation 1
        'md-2': '0 3px 6px rgba(0,0,0,0.16)', // Material elevation 2
        // ... other elevations
      },
    },
  },
}
```

**Best Practices**:
- Keep Material tokens in Tailwind config
- Build component library (universo-template) with Material styles
- Use Tailwind @apply sparingly (prefer utility classes in HTML)
- Enable JIT mode for fast compilation

---

### 6. Testing Strategy: RSpec + FactoryBot + Capybara

**Decision**: Full testing stack with RSpec as primary framework

**Rationale**:
- RSpec is Ruby standard for BDD testing
- FactoryBot provides clean test data generation
- Capybara enables feature testing (user journey simulation)
- SimpleCov tracks code coverage
- All tools have excellent Rails integration

**Testing Layers**:

**Unit Tests (RSpec + FactoryBot)**:
```ruby
# spec/models/clusters/cluster_spec.rb
RSpec.describe Clusters::Cluster do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
  
  describe 'associations' do
    it { should have_many(:domains) }
  end
end
```

**Controller Tests**:
```ruby
# spec/controllers/clusters/clusters_controller_spec.rb
RSpec.describe Clusters::ClustersController do
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to be_successful
    end
  end
end
```

**Feature Tests (Capybara)**:
```ruby
# spec/features/cluster_management_spec.rb
RSpec.feature 'Cluster Management' do
  scenario 'User creates a new cluster' do
    visit clusters_path
    click_link 'New Cluster'
    fill_in 'Name', with: 'Test Cluster'
    click_button 'Create'
    expect(page).to have_content('Cluster created successfully')
  end
end
```

**Component Tests (ViewComponent + RSpec)**:
```ruby
# spec/components/clusters/card_component_spec.rb
RSpec.describe Clusters::CardComponent do
  it 'renders cluster name' do
    cluster = build(:cluster, name: 'Test')
    render_inline(described_class.new(cluster: cluster))
    expect(page).to have_content('Test')
  end
end
```

**Best Practices**:
- 80% minimum coverage (enforced by SimpleCov)
- Mock external services (Supabase Auth) in unit tests
- Test all CRUD operations
- Feature tests for critical user journeys
- FactoryBot for realistic test data

---

### 7. Code Quality: RuboCop + Brakeman + Bundler-audit

**Decision**: Three-tool approach for code quality

**RuboCop** (Style & Best Practices):
- Ruby style guide enforcement
- Rails-specific cops for framework best practices
- Custom configuration in `.rubocop.yml`
- Run on pre-commit and CI

**Brakeman** (Security Scanning):
- Static analysis for security vulnerabilities
- Detects SQL injection, XSS, unsafe redirects
- Run on CI before merge

**Bundler-audit** (Dependency Security):
- Checks Gemfile.lock for known vulnerabilities
- Uses Ruby Advisory Database
- Run on CI and scheduled jobs

**CI/CD Integration**:
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
      - run: bundle install
      - run: bundle exec rubocop
      - run: bundle exec brakeman
      - run: bundle exec bundler-audit check --update
      - run: bundle exec rspec
```

**Best Practices**:
- Fix RuboCop issues before commit
- Address Brakeman warnings (don't ignore without justification)
- Keep dependencies updated
- Security is a gate for merging

---

### 8. Bilingual Documentation Strategy

**Decision**: Parallel English/Russian files with automated verification

**Requirements from Constitution**:
- README.md (English) is primary standard
- README-RU.md (Russian) must have identical line count
- Same structure and content, just translated
- Verification before merge

**Implementation**:
- Write English documentation first
- Translate to Russian maintaining structure
- Script to verify line count parity

**Verification Script**:
```bash
#!/bin/bash
# .github/scripts/verify-i18n.sh

errors=0

for file in $(find . -name "README.md"); do
  ru_file="${file%.md}-RU.md"
  if [ -f "$ru_file" ]; then
    en_lines=$(wc -l < "$file")
    ru_lines=$(wc -l < "$ru_file")
    if [ "$en_lines" -ne "$ru_lines" ]; then
      echo "ERROR: Line count mismatch"
      echo "  $file: $en_lines lines"
      echo "  $ru_file: $ru_lines lines"
      errors=$((errors + 1))
    fi
  else
    echo "ERROR: Missing Russian translation: $ru_file"
    errors=$((errors + 1))
  fi
done

exit $errors
```

**CI Integration**:
```yaml
- name: Verify bilingual documentation
  run: .github/scripts/verify-i18n.sh
```

**Best Practices**:
- Always update English first
- Translate immediately (not as technical debt)
- Use consistent terminology in both languages
- Code examples identical in both versions
- Comments in code remain English only

---

### 9. GitHub Workflow Configuration

**Decision**: Comprehensive GitHub workflow with templates and automation

**Components**:

**Issue Templates**:
- Bug report template
- Feature request template
- Enhancement template
- Question template

**PR Template**:
- Checklist (tests, documentation, translations)
- Related issues links
- Screenshot requirement for UI changes
- Security consideration section

**Labels** (per `.github/instructions/github-labels.md`):
- Priority: P0-P3
- Type: bug, feature, enhancement, documentation
- Status: in-progress, blocked, needs-review
- Area: backend, frontend, database, auth

**GitHub Actions Workflows**:
1. **CI Workflow** (on push/PR):
   - Install dependencies
   - Run RuboCop
   - Run Brakeman
   - Run tests with coverage
   - Verify bilingual documentation
   
2. **Security Audit** (scheduled weekly):
   - Run Bundler-audit
   - Check for outdated dependencies
   
3. **Deploy** (on main branch):
   - Build Docker image
   - Run migrations
   - Deploy to staging/production

**Best Practices**:
- All checks must pass before merge
- Use branch protection rules
- Require code review before merge
- Semantic commit messages (feat:, fix:, docs:, refactor:, test:, chore:)

---

### 10. Clusters Package Architecture (Reference Implementation)

**Decision**: Three-entity hierarchy with Rails Engine isolation

**Entities**:
1. **Cluster**: Top-level organizational unit
2. **Domain**: Mid-level, belongs to Cluster
3. **Resource**: Bottom-level, belongs to Domain

**Relationships**:
- Cluster has_many Domains (through junction table for many-to-many support)
- Domain belongs_to Cluster
- Domain has_many Resources (through junction table)
- Resource belongs_to Domain
- All entities belong_to User (isolation per user)

**Database Schema**:
```ruby
# Clusters table
create_table :clusters_clusters do |t|
  t.string :name, null: false
  t.text :description
  t.references :user, null: false, foreign_key: true
  t.timestamps
end

# Domains table
create_table :clusters_domains do |t|
  t.string :name, null: false
  t.text :description
  t.timestamps
end

# Resources table
create_table :clusters_resources do |t|
  t.string :name, null: false
  t.string :resource_type
  t.jsonb :configuration, default: {}
  t.timestamps
end

# Junction tables
create_table :clusters_cluster_domains do |t|
  t.references :cluster, null: false, foreign_key: { to_table: :clusters_clusters }
  t.references :domain, null: false, foreign_key: { to_table: :clusters_domains }
  t.timestamps
  t.index [:cluster_id, :domain_id], unique: true
end

create_table :clusters_domain_resources do |t|
  t.references :domain, null: false, foreign_key: { to_table: :clusters_domains }
  t.references :resource, null: false, foreign_key: { to_table: :clusters_resources }
  t.timestamps
  t.index [:domain_id, :resource_id], unique: true
end
```

**RESTful Routes**:
```ruby
# packages/clusters-srv/base/config/routes.rb
Clusters::Engine.routes.draw do
  resources :clusters do
    resources :domains, only: [:create, :destroy]
  end
  
  resources :domains do
    resources :resources, only: [:create, :destroy]
  end
  
  resources :resources, only: [:index, :show, :update, :destroy]
end
```

**Authorization**:
- Before_action to verify cluster belongs to current_user
- Prevent deletion of Cluster with Domains
- Prevent deletion of Domain with Resources
- Soft delete implementation using `discarded_at` column

**This pattern serves as template for future packages**:
- Metaverses (Metaverse → Section → Entity)
- Uniks (more levels if needed)
- Other hierarchical features

---

## Technology Choices Summary

| Category | Technology | Rationale |
|----------|-----------|-----------|
| Language/Framework | Ruby 3.2+ / Rails 7.0+ | Constitution requirement, mature ecosystem |
| Database | PostgreSQL via Supabase | Cloud-hosted, Auth included, real-time capable |
| Authentication | Supabase Auth + JWT | Integrated with database, proven solution |
| Package Management | Rails Engines + Bundler | Native Rails, proper isolation, gem-ready |
| Frontend Framework | Hotwire (Turbo + Stimulus) | Rails-native, server-rendered, SPA-like UX |
| UI Components | ViewComponent | Testable, performant, object-oriented |
| Styling | Tailwind CSS + Material Design | Utility-first, customizable, lightweight |
| Testing | RSpec + FactoryBot + Capybara | Industry standard, comprehensive coverage |
| Code Quality | RuboCop + Brakeman + Bundler-audit | Style, security, dependencies |
| CI/CD | GitHub Actions | Integrated, free for public repos |
| Containerization | Docker | Consistent environments, easy deployment |

---

## Risk Mitigation

### Risk: Supabase Vendor Lock-in
**Mitigation**: 
- Use standard PostgreSQL connection (portable)
- Abstract Supabase Auth behind authentication service layer
- Document migration path to self-hosted PostgreSQL + custom auth

### Risk: Rails Engine Complexity
**Mitigation**:
- Start with well-documented reference (Clusters)
- Create package creation checklist
- Provide engine templates for common patterns

### Risk: Bilingual Documentation Drift
**Mitigation**:
- Automated verification in CI
- Block merge if line counts don't match
- Document translation process clearly

### Risk: React Repository Divergence
**Mitigation**:
- Create FEATURE_PARITY.md tracking document
- Weekly review of React repository updates
- Focus on feature parity, not code parity

---

## Next Steps (Phase 1)

With research complete, proceed to Phase 1:

1. **Generate data-model.md**:
   - Document Cluster/Domain/Resource entities
   - Define relationships and validations
   - Specify database schema with indexes

2. **Create API contracts/**:
   - OpenAPI/JSON Schema for REST endpoints
   - Document request/response formats
   - Error response structures

3. **Generate quickstart.md**:
   - Step-by-step setup instructions
   - Environment configuration
   - First cluster creation guide

4. **Update agent context**:
   - Run `.specify/scripts/bash/update-agent-context.sh copilot`
   - Add technology choices to agent knowledge

5. **Re-evaluate Constitution Check**:
   - Verify design aligns with constitutional principles
   - Document any complexities requiring justification

---

**Research Status**: ✅ COMPLETE  
**Ready for Phase 1**: YES  
**Blockers**: NONE
