# Ruby on Rails Best Practices Research 2024

**Date**: 2025-11-17  
**Purpose**: Research best technical solutions, patterns, and practices for Ruby on Rails to enhance the Universo Platformo Ruby implementation  
**Sources**: Web search results, Context7 documentation, Rails official guides  

---

## Executive Summary

This document consolidates the latest (2024) best practices and technical patterns for Ruby on Rails development, specifically researched to inform the Universo Platformo Ruby project implementation. All findings align with the project's goals of creating a modular, maintainable, and scalable Rails monorepo.

**Key Findings**:
- ✅ Rails 7 Engines are the recommended approach for modular monoliths
- ✅ Hotwire (Turbo + Stimulus) is the modern Rails frontend standard
- ✅ ViewComponent provides the best pattern for reusable UI components
- ✅ Supabase integration with Rails RLS is well-supported
- ✅ RESTful API patterns with structured error handling are industry standard
- ✅ RSpec with FactoryBot and Capybara remains the testing gold standard

---

## 1. Monorepo Architecture with Rails Engines

### Industry Best Practices (2024)

**Key Pattern: Modular Monolithic Architecture**

Modern Rails applications are increasingly adopting "modular monoliths" using Rails Engines to maintain modularity without the operational complexity of microservices.

#### Directory Structure
```
/
├── apps/                    # Main Rails applications
├── engines/                 # Domain-specific Rails Engines
│   ├── clusters/
│   │   ├── app/
│   │   ├── config/
│   │   ├── lib/
│   │   └── clusters.gemspec
│   ├── metaverses/
│   └── spaces/
├── libs/                    # Shared utility gems
│   ├── universo-utils/
│   ├── universo-api/
│   └── universo-types/
└── Gemfile                  # Unified dependency management
```

#### Engine Organization Principles

1. **Clear Domain Boundaries**: Each engine represents a distinct business domain (e.g., clusters, metaverses, authentication)

2. **Namespace Isolation**: Use `isolate_namespace` to prevent naming conflicts
   ```ruby
   module Clusters
     class Engine < ::Rails::Engine
       isolate_namespace Clusters
     end
   end
   ```

3. **Explicit Dependencies**: Engines should only access allowed dependencies
   ```ruby
   # engines/clusters/clusters.gemspec
   spec.add_dependency "rails", "~> 7.0"
   spec.add_dependency "universo-utils"
   ```

4. **Unified Dependency Versions**: All engines use the same gem versions via root Gemfile

#### Benefits Over Microservices

- **Faster Development**: Familiar Rails tooling, shared database
- **Fewer Operations Overhead**: Single deployment, no service mesh complexity
- **Controlled Boundaries**: Clear module separation without network calls
- **Easier Testing**: Integration tests across domains without complex mocking

#### Rails Engine Best Practices from Context7

**Engine Definition Pattern**:
```ruby
# engines/clusters/lib/clusters/engine.rb
module Clusters
  class Engine < ::Rails::Engine
    isolate_namespace Clusters
    
    # Engine-specific configuration
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
```

**Mounting in Application**:
```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount Clusters::Engine => "/clusters"
  mount Metaverses::Engine => "/metaverses"
  mount Spaces::Engine => "/spaces"
end
```

**Engine Routes**:
```ruby
# engines/clusters/config/routes.rb
Clusters::Engine.routes.draw do
  resources :clusters do
    resources :domains do
      resources :resources
    end
  end
end
```

#### Comparison with React Monorepo

**React (PNPM + Turbo)**:
- Uses `pnpm-workspace.yaml` for package management
- Build orchestration via `turbo.json`
- Separate frontend/backend packages

**Rails Engine Equivalent**:
- Uses Bundler for gem management
- Rails autoloading for code organization
- Engines encapsulate both frontend and backend in one unit
- More integrated, less separation needed

### Recommendations for Universo Platformo Ruby

1. **Adopt Rails Engines**: Use engines in `packages/` directory (following current structure)
2. **Engine Naming**: Keep `-frt/-srv` naming but implement as single engine per domain when possible
3. **Shared Utilities**: Create `engines/universo-*` for shared concerns
4. **Testing Strategy**: Each engine has its own test suite, run selectively in CI/CD

---

## 2. Hotwire (Turbo + Stimulus) Best Practices

### Modern Rails Frontend Architecture

Hotwire represents the Rails 7 approach to reactive UIs without heavy JavaScript frameworks.

#### Turbo Drive
- Automatically speeds up navigation by intercepting link clicks
- Enabled by default in Rails 7
- Converts standard Rails apps into SPA-like experiences

#### Turbo Frames

**Purpose**: Isolate page sections for independent updates

**Best Practices**:
1. **Unique Frame IDs**: Use `dom_id(model)` for automatic, unique identifiers
   ```erb
   <%= turbo_frame_tag @cluster do %>
     <h2><%= @cluster.name %></h2>
     <%= link_to "Edit", edit_cluster_path(@cluster) %>
   <% end %>
   ```

2. **Avoid Deep Nesting**: Keep frame hierarchies shallow for predictable behavior

3. **Lazy Loading**: Use `src` and `loading: "lazy"` for deferred content
   ```erb
   <%= turbo_frame_tag "notifications", 
       src: notifications_path, 
       loading: "lazy" %>
   ```

4. **Breaking Out**: Use `data-turbo-frame="_top"` to navigate entire page
   ```erb
   <%= link_to "Dashboard", dashboard_path, 
       data: { turbo_frame: "_top" } %>
   ```

#### Turbo Streams

**Purpose**: Real-time, granular DOM updates via ActionCable

**Common Actions**:
- `append`: Add element to end of target
- `prepend`: Add element to start of target
- `replace`: Replace entire target
- `update`: Replace target's contents
- `remove`: Delete target element

**Controller Pattern**:
```ruby
class ClustersController < ApplicationController
  def create
    @cluster = Cluster.create!(cluster_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to clusters_path }
    end
  end
end
```

**View Pattern**:
```erb
<%# app/views/clusters/create.turbo_stream.erb %>
<%= turbo_stream.append "clusters", @cluster %>
<%= turbo_stream.update "cluster_count" do %>
  <%= pluralize(Cluster.count, "cluster") %>
<% end %>
```

**Broadcasting Pattern**:
```ruby
class Cluster < ApplicationRecord
  after_create_commit do
    broadcast_append_to "clusters",
      target: "clusters_list",
      partial: "clusters/cluster",
      locals: { cluster: self }
  end
end
```

**Subscription Pattern**:
```erb
<%# app/views/clusters/index.html.erb %>
<%= turbo_stream_from "clusters" %>
<div id="clusters_list">
  <%= render @clusters %>
</div>
```

#### Stimulus Controllers

**Purpose**: Add client-side interactivity where Turbo isn't sufficient

**Best Practices**:

1. **Single Responsibility**: Each controller does one thing
   ```javascript
   // app/javascript/controllers/toggle_controller.js
   import { Controller } from "@hotwired/stimulus"
   
   export default class extends Controller {
     static targets = ["content"]
     
     toggle() {
       this.contentTarget.classList.toggle("hidden")
     }
   }
   ```

2. **Clear Naming**: Use descriptive controller names
   - `modal_controller.js` for modals
   - `dropdown_controller.js` for dropdowns
   - `autocomplete_controller.js` for autocomplete

3. **Data Attributes**: Use data attributes for configuration
   ```erb
   <div data-controller="modal" 
        data-modal-close-on-escape="true"
        data-modal-backdrop-dismissible="true">
   ```

4. **Minimal JavaScript**: Keep logic in Stimulus minimal, delegate to Turbo when possible

#### Accessibility Considerations

**Modal Pattern** (from AppSignal guide):
```javascript
// app/javascript/controllers/modal_controller.js
export default class extends Controller {
  static targets = ["container"]
  
  connect() {
    // Trap focus in modal
    this.trapFocus()
    // Handle ESC key
    this.escapeHandler = this.close.bind(this)
    document.addEventListener("keydown", this.escapeHandler)
  }
  
  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }
  
  trapFocus() {
    // Implementation for focus trap
  }
  
  close(event) {
    if (event.key === "Escape") {
      this.containerTarget.remove()
    }
  }
}
```

### Recommendations for Universo Platformo Ruby

1. **Use Turbo Frames**: For all partial page updates (cluster cards, domain lists)
2. **Use Turbo Streams**: For real-time updates (new cluster notifications, collaborative editing)
3. **Use Stimulus**: For UI interactions (modals, dropdowns, form enhancements)
4. **Follow Hotwire Cheatsheet**: Reference official patterns for common scenarios

---

## 3. ViewComponent Best Practices

### Component-Based UI Architecture

ViewComponent brings component-based architecture to Rails views, similar to React components.

#### Core Principles

**Philosophy**: ViewComponent is to UI what ActiveRecord is to SQL
- Isolate and reuse UI patterns
- Reduce duplication
- Improve testability
- Expose complexity explicitly

#### Identifying Reusable Components

**When to Create Components**:
1. **Repeated HTML**: Same markup appears 3+ times
2. **UI Patterns**: Cards, buttons, navbars, modals, alerts
3. **Domain Objects**: User avatar, cluster card, domain list item

**Component Organization**:
```
app/
└── components/
    ├── universo/           # General-purpose components
    │   ├── button_component.rb
    │   ├── card_component.rb
    │   └── modal_component.rb
    ├── clusters/           # Domain-specific components
    │   ├── cluster_card_component.rb
    │   └── domain_list_component.rb
    └── shared/             # Cross-domain components
        └── user_avatar_component.rb
```

#### Implementation Best Practices

**1. Clear Component Definition**:
```ruby
# app/components/clusters/cluster_card_component.rb
class Clusters::ClusterCardComponent < ViewComponent::Base
  def initialize(cluster:, show_actions: true)
    @cluster = cluster
    @show_actions = show_actions
  end

  private

  attr_reader :cluster, :show_actions

  def formatted_created_at
    cluster.created_at.strftime("%B %d, %Y")
  end
end
```

**2. Clean Templates**:
```erb
<%# app/components/clusters/cluster_card_component.html.erb %>
<div class="cluster-card" id="<%= dom_id(cluster) %>">
  <h3><%= cluster.name %></h3>
  <p><%= cluster.description %></p>
  <footer>
    <time><%= formatted_created_at %></time>
    <% if show_actions %>
      <%= link_to "Edit", edit_cluster_path(cluster) %>
    <% end %>
  </footer>
</div>
```

**3. Using Slots for Flexibility**:
```ruby
# app/components/universo/card_component.rb
class Universo::CardComponent < ViewComponent::Base
  renders_one :header
  renders_one :body
  renders_many :actions
  
  def initialize(title: nil)
    @title = title
  end
end
```

```erb
<%# Usage %>
<%= render Universo::CardComponent.new(title: "Cluster") do |card| %>
  <% card.with_header do %>
    <h3>Custom Header</h3>
  <% end %>
  
  <% card.with_body do %>
    <p>Card content here</p>
  <% end %>
  
  <% card.with_action do %>
    <%= link_to "Edit", edit_path %>
  <% end %>
  
  <% card.with_action do %>
    <%= link_to "Delete", delete_path %>
  <% end %>
<% end %>
```

#### Testing ViewComponents

**Unit Testing Pattern**:
```ruby
# spec/components/clusters/cluster_card_component_spec.rb
require "rails_helper"

RSpec.describe Clusters::ClusterCardComponent, type: :component do
  let(:cluster) { create(:cluster, name: "Test Cluster") }
  
  it "renders cluster name" do
    render_inline(described_class.new(cluster: cluster))
    
    expect(page).to have_text("Test Cluster")
  end
  
  context "when show_actions is false" do
    it "does not render edit link" do
      render_inline(described_class.new(cluster: cluster, show_actions: false))
      
      expect(page).not_to have_link("Edit")
    end
  end
end
```

#### Naming Conventions

- **Suffix**: Always use `Component` (e.g., `UserAvatarComponent`)
- **Plural Modules**: Follow Rails conventions (e.g., `Users::AvatarComponent`)
- **Location**: Store in `app/components/` directory

#### Integration with Tailwind CSS

**Material Design Theme with Tailwind**:
```ruby
# app/components/universo/button_component.rb
class Universo::ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "bg-blue-600 hover:bg-blue-700 text-white",
    secondary: "bg-gray-200 hover:bg-gray-300 text-gray-900",
    danger: "bg-red-600 hover:bg-red-700 text-white"
  }.freeze
  
  def initialize(variant: :primary, **attrs)
    @variant = variant
    @attrs = attrs
  end
  
  def css_classes
    "px-4 py-2 rounded-md font-medium transition #{VARIANTS[@variant]}"
  end
end
```

### Recommendations for Universo Platformo Ruby

1. **Create Component Library**: Build `universo-*` components for reuse across packages
2. **Use Slots**: Leverage slots for flexible, customizable components
3. **Test Components**: Unit test all components with RSpec
4. **Material Design**: Implement Material Design patterns with Tailwind CSS classes
5. **Avoid Inheritance**: Use composition over inheritance for component relationships

---

## 4. Supabase Integration with Rails

### Database-First Architecture with Supabase

Supabase provides PostgreSQL database, authentication, and real-time features with excellent Rails compatibility.

#### Connection Setup

**Database Configuration**:
```yaml
# config/database.yml
production:
  <<: *default
  url: <%= ENV['SUPABASE_DATABASE_URL'] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

**Environment Variables**:
```bash
# .env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
SUPABASE_DATABASE_URL=postgresql://postgres:[password]@db.your-project.supabase.co:5432/postgres
```

#### Supabase Auth Integration

**Session Management Approach**:
1. Frontend authenticates with Supabase
2. Supabase returns JWT token
3. Rails validates JWT token for API requests
4. Rails uses JWT claims for authorization

**JWT Validation Pattern**:
```ruby
# app/controllers/concerns/supabase_authentication.rb
module SupabaseAuthentication
  extend ActiveSupport::Concern
  
  included do
    before_action :authenticate_supabase_user
  end
  
  private
  
  def authenticate_supabase_user
    token = request.headers['Authorization']&.split(' ')&.last
    return render json: { error: 'Unauthorized' }, status: 401 unless token
    
    @current_user_id = decode_supabase_token(token)
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: 401
  end
  
  def decode_supabase_token(token)
    secret = ENV['SUPABASE_JWT_SECRET']
    decoded = JWT.decode(token, secret, true, { algorithm: 'HS256' })
    decoded.first['sub'] # User ID from token
  end
  
  def current_user_id
    @current_user_id
  end
end
```

#### Row-Level Security (RLS) with Rails

**Policy Creation Pattern**:
```sql
-- Enable RLS on clusters table
ALTER TABLE clusters ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see clusters they're members of
CREATE POLICY "cluster_member_select"
  ON clusters
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM cluster_members
      WHERE cluster_members.cluster_id = clusters.id
        AND cluster_members.user_id = auth.uid()
    )
  );

-- Policy: Only owners can delete clusters
CREATE POLICY "cluster_owner_delete"
  ON clusters
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM cluster_members
      WHERE cluster_members.cluster_id = clusters.id
        AND cluster_members.user_id = auth.uid()
        AND cluster_members.role = 'owner'
    )
  );
```

**Rails Migration for RLS**:
```ruby
class EnableRowLevelSecurityOnClusters < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE clusters ENABLE ROW LEVEL SECURITY;
      
      CREATE POLICY cluster_member_select ON clusters
        FOR SELECT
        USING (
          EXISTS (
            SELECT 1 FROM cluster_members
            WHERE cluster_members.cluster_id = clusters.id
              AND cluster_members.user_id = current_setting('app.current_user_id')::uuid
          )
        );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP POLICY IF EXISTS cluster_member_select ON clusters;
      ALTER TABLE clusters DISABLE ROW LEVEL SECURITY;
    SQL
  end
end
```

**Setting Current User Context**:
```ruby
# app/models/concerns/supabase_rls.rb
module SupabaseRls
  extend ActiveSupport::Concern
  
  def self.with_user_context(user_id)
    ActiveRecord::Base.connection.execute(
      "SET LOCAL app.current_user_id = '#{user_id}'"
    )
    yield
  ensure
    ActiveRecord::Base.connection.execute(
      "RESET app.current_user_id"
    )
  end
end
```

**Controller Integration**:
```ruby
class ClustersController < ApplicationController
  include SupabaseAuthentication
  
  def index
    SupabaseRls.with_user_context(current_user_id) do
      @clusters = Cluster.all # RLS automatically filters
    end
    render json: @clusters
  end
end
```

#### Best Practices for Supabase + Rails

1. **Defense in Depth**: Use both RLS (database) and Rails authorization (application)
2. **Test RLS Policies**: Write tests to verify RLS policies work correctly
3. **Index RLS Columns**: Add indexes on columns used in RLS policies for performance
4. **Document Policies**: Comment all RLS policies with their purpose
5. **Monitor Performance**: Track query performance with RLS policies

### Recommendations for Universo Platformo Ruby

1. **Implement RLS**: Use RLS for all multi-tenant tables (clusters, domains, resources)
2. **JWT Validation**: Create middleware for JWT token validation
3. **User Context**: Always set user context before database queries
4. **Test RLS**: Include RLS policy tests in RSpec suite
5. **Document Security**: Maintain security documentation for all policies

---

## 5. RESTful API Design Patterns

### Modern Rails API Best Practices

Rails 7 provides excellent support for building RESTful APIs with consistent patterns.

#### Resource-Based Architecture

**Core Principles**:
1. **Plural Nouns**: Use plural nouns for resources (`/clusters`, `/domains`)
2. **Nested Resources**: Reflect relationships (`/clusters/:id/domains`)
3. **HTTP Methods**: Map CRUD to HTTP verbs (GET, POST, PUT/PATCH, DELETE)
4. **Stateless**: Each request is independent, no server-side session

#### API Controller Structure

**Base API Controller**:
```ruby
# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ActionController::API
      include SupabaseAuthentication
      include ApiErrorHandling
      include ApiPagination
      
      before_action :set_default_format
      
      private
      
      def set_default_format
        request.format = :json
      end
    end
  end
end
```

**Resource Controller Pattern**:
```ruby
# app/controllers/api/v1/clusters_controller.rb
module Api
  module V1
    class ClustersController < BaseController
      def index
        @clusters = Cluster.accessible_by(current_user)
                          .page(params[:page])
                          .per(params[:per_page] || 25)
        
        render json: @clusters, meta: pagination_meta(@clusters)
      end
      
      def show
        @cluster = Cluster.find(params[:id])
        authorize! :read, @cluster
        
        render json: @cluster
      end
      
      def create
        @cluster = Cluster.new(cluster_params)
        @cluster.created_by = current_user
        
        if @cluster.save
          render json: @cluster, status: :created
        else
          render json: { errors: @cluster.errors }, status: :unprocessable_entity
        end
      end
      
      def update
        @cluster = Cluster.find(params[:id])
        authorize! :update, @cluster
        
        if @cluster.update(cluster_params)
          render json: @cluster
        else
          render json: { errors: @cluster.errors }, status: :unprocessable_entity
        end
      end
      
      def destroy
        @cluster = Cluster.find(params[:id])
        authorize! :destroy, @cluster
        
        @cluster.destroy
        head :no_content
      end
      
      private
      
      def cluster_params
        params.require(:cluster).permit(:name, :description, :visibility)
      end
    end
  end
end
```

#### Query Parameter Standards

**Filtering**:
```ruby
# GET /api/v1/clusters?filter[status]=active&filter[visibility]=public
def index
  @clusters = Cluster.all
  
  if params[:filter].present?
    @clusters = @clusters.where(status: params[:filter][:status]) if params[:filter][:status]
    @clusters = @clusters.where(visibility: params[:filter][:visibility]) if params[:filter][:visibility]
  end
  
  render json: @clusters
end
```

**Sorting**:
```ruby
# GET /api/v1/clusters?sort=-created_at,name
def index
  @clusters = Cluster.all
  
  if params[:sort].present?
    sort_params = params[:sort].split(',')
    sort_params.each do |param|
      direction = param.start_with?('-') ? :desc : :asc
      column = param.delete_prefix('-')
      @clusters = @clusters.order(column => direction)
    end
  end
  
  render json: @clusters
end
```

**Pagination**:
```ruby
# GET /api/v1/clusters?page=2&per_page=25
module ApiPagination
  extend ActiveSupport::Concern
  
  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end
```

**Field Selection**:
```ruby
# GET /api/v1/clusters?fields=id,name,created_at
def index
  fields = params[:fields]&.split(',') || Cluster.column_names
  @clusters = Cluster.select(fields)
  
  render json: @clusters
end
```

#### Error Handling Patterns

**Structured Error Response**:
```ruby
# app/controllers/concerns/api_error_handling.rb
module ApiErrorHandling
  extend ActiveSupport::Concern
  
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  end
  
  private
  
  def record_not_found(exception)
    render json: {
      error: {
        code: 404,
        message: "Record not found",
        details: exception.message
      }
    }, status: :not_found
  end
  
  def record_invalid(exception)
    render json: {
      error: {
        code: 422,
        message: "Validation failed",
        details: exception.record.errors.full_messages
      }
    }, status: :unprocessable_entity
  end
  
  def parameter_missing(exception)
    render json: {
      error: {
        code: 400,
        message: "Missing required parameter",
        details: exception.message
      }
    }, status: :bad_request
  end
  
  def not_authorized
    render json: {
      error: {
        code: 403,
        message: "Access denied",
        details: "You are not authorized to perform this action"
      }
    }, status: :forbidden
  end
end
```

**HTTP Status Code Guide**:
- **200 OK**: Successful GET, PUT, PATCH
- **201 Created**: Successful POST
- **204 No Content**: Successful DELETE
- **400 Bad Request**: Invalid request parameters
- **401 Unauthorized**: Missing or invalid authentication
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource doesn't exist
- **422 Unprocessable Entity**: Validation failed
- **500 Internal Server Error**: Server-side error

#### API Versioning

**URL Versioning Pattern**:
```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :clusters do
        resources :domains do
          resources :resources
        end
      end
    end
  end
end
```

#### Idempotency

**Idempotency Key Pattern**:
```ruby
# app/controllers/concerns/idempotent_requests.rb
module IdempotentRequests
  extend ActiveSupport::Concern
  
  def ensure_idempotency
    return unless request.post? || request.patch? || request.put?
    
    key = request.headers['Idempotency-Key']
    return unless key
    
    cached = Rails.cache.read("idempotency:#{key}")
    if cached
      render json: cached[:body], status: cached[:status]
      return
    end
    
    yield
    
    Rails.cache.write(
      "idempotency:#{key}",
      { body: response.body, status: response.status },
      expires_in: 24.hours
    )
  end
end
```

### Recommendations for Universo Platformo Ruby

1. **API Versioning**: Use `/api/v1/` namespace from the start
2. **Structured Errors**: Implement consistent error response format
3. **Query Standards**: Support filtering, sorting, pagination, field selection
4. **Status Codes**: Use appropriate HTTP status codes consistently
5. **Idempotency**: Support idempotency keys for write operations
6. **Documentation**: Generate OpenAPI/Swagger documentation

---

## 6. Testing Strategies with RSpec

### Comprehensive Rails Testing Approach

RSpec with FactoryBot and Capybara is the gold standard for Rails testing in 2024.

#### Test Organization

**Directory Structure**:
```
spec/
├── factories/              # FactoryBot factories
│   ├── clusters.rb
│   ├── domains.rb
│   └── users.rb
├── models/                 # Model specs
│   ├── cluster_spec.rb
│   └── domain_spec.rb
├── requests/              # API/Request specs
│   └── api/
│       └── v1/
│           └── clusters_spec.rb
├── system/                # System/Feature specs with Capybara
│   ├── clusters/
│   │   ├── create_spec.rb
│   │   └── edit_spec.rb
│   └── authentication_spec.rb
├── components/            # ViewComponent specs
│   └── clusters/
│       └── cluster_card_component_spec.rb
├── support/               # Test helpers
│   ├── auth_helpers.rb
│   ├── api_helpers.rb
│   └── rls_helpers.rb
└── rails_helper.rb        # RSpec configuration
```

#### FactoryBot Best Practices

**Factory Definition**:
```ruby
# spec/factories/clusters.rb
FactoryBot.define do
  factory :cluster, class: 'Clusters::Cluster' do
    sequence(:name) { |n| "Cluster #{n}" }
    description { Faker::Lorem.paragraph }
    visibility { :public }
    created_by { association :user }
    
    trait :private do
      visibility { :private }
    end
    
    trait :with_domains do
      transient do
        domains_count { 3 }
      end
      
      after(:create) do |cluster, evaluator|
        create_list(:domain, evaluator.domains_count, clusters: [cluster])
      end
    end
  end
end
```

**Factory Usage**:
```ruby
# Build without saving (no DB hit)
cluster = build(:cluster)

# Build with stubbed ID (faster than build)
cluster = build_stubbed(:cluster)

# Create and save to database
cluster = create(:cluster)

# Create with trait
private_cluster = create(:cluster, :private)

# Create with associations
cluster_with_domains = create(:cluster, :with_domains, domains_count: 5)

# Use attributes_for for request specs
cluster_attributes = attributes_for(:cluster)
post api_v1_clusters_path, params: { cluster: cluster_attributes }
```

#### Model Testing Pattern

**Model Spec Structure**:
```ruby
# spec/models/cluster_spec.rb
require 'rails_helper'

RSpec.describe Clusters::Cluster, type: :model do
  describe 'associations' do
    it { should have_many(:cluster_members).dependent(:destroy) }
    it { should have_many(:users).through(:cluster_members) }
    it { should have_many(:cluster_domains).dependent(:destroy) }
    it { should have_many(:domains).through(:cluster_domains) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_presence_of(:created_by) }
    
    context 'when visibility is present' do
      it { should validate_inclusion_of(:visibility).in_array(%w[public private]) }
    end
  end
  
  describe 'scopes' do
    let!(:public_cluster) { create(:cluster, visibility: :public) }
    let!(:private_cluster) { create(:cluster, :private) }
    
    describe '.public_clusters' do
      it 'returns only public clusters' do
        expect(Cluster.public_clusters).to include(public_cluster)
        expect(Cluster.public_clusters).not_to include(private_cluster)
      end
    end
  end
  
  describe '#accessible_by?' do
    let(:cluster) { create(:cluster) }
    let(:owner) { cluster.created_by }
    let(:member) { create(:user) }
    let(:stranger) { create(:user) }
    
    before do
      create(:cluster_member, cluster: cluster, user: member, role: :member)
    end
    
    it 'returns true for owner' do
      expect(cluster.accessible_by?(owner)).to be true
    end
    
    it 'returns true for member' do
      expect(cluster.accessible_by?(member)).to be true
    end
    
    it 'returns false for non-member' do
      expect(cluster.accessible_by?(stranger)).to be false
    end
  end
end
```

#### Request Spec Pattern

**API Request Testing**:
```ruby
# spec/requests/api/v1/clusters_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Clusters', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { generate_jwt_token(user) }
  let(:headers) do
    {
      'Authorization' => "Bearer #{auth_token}",
      'Content-Type' => 'application/json'
    }
  end
  
  describe 'GET /api/v1/clusters' do
    let!(:clusters) { create_list(:cluster, 3, created_by: user) }
    
    it 'returns all accessible clusters' do
      get api_v1_clusters_path, headers: headers
      
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
    
    it 'filters by status' do
      active_cluster = create(:cluster, status: :active, created_by: user)
      archived_cluster = create(:cluster, status: :archived, created_by: user)
      
      get api_v1_clusters_path, 
          params: { filter: { status: 'active' } },
          headers: headers
      
      expect(json_response.size).to eq(1)
      expect(json_response.first['id']).to eq(active_cluster.id)
    end
    
    it 'paginates results' do
      create_list(:cluster, 30, created_by: user)
      
      get api_v1_clusters_path,
          params: { page: 2, per_page: 10 },
          headers: headers
      
      expect(json_response.size).to eq(10)
      expect(response.headers['X-Page']).to eq('2')
    end
  end
  
  describe 'POST /api/v1/clusters' do
    let(:valid_params) do
      {
        cluster: attributes_for(:cluster)
      }
    end
    
    context 'with valid parameters' do
      it 'creates a new cluster' do
        expect {
          post api_v1_clusters_path,
               params: valid_params.to_json,
               headers: headers
        }.to change(Cluster, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(json_response['name']).to eq(valid_params[:cluster][:name])
      end
    end
    
    context 'with invalid parameters' do
      let(:invalid_params) do
        { cluster: { name: '' } }
      end
      
      it 'returns unprocessable entity' do
        post api_v1_clusters_path,
             params: invalid_params.to_json,
             headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']['code']).to eq(422)
        expect(json_response['error']['details']).to include("Name can't be blank")
      end
    end
  end
  
  private
  
  def json_response
    JSON.parse(response.body)
  end
end
```

#### System Spec Pattern with Capybara

**Feature Testing**:
```ruby
# spec/system/clusters/create_spec.rb
require 'rails_helper'

RSpec.describe 'Creating a cluster', type: :system do
  let(:user) { create(:user) }
  
  before do
    sign_in user
  end
  
  it 'allows user to create a new cluster' do
    visit clusters_path
    click_link 'New Cluster'
    
    fill_in 'Name', with: 'My First Cluster'
    fill_in 'Description', with: 'This is a test cluster'
    select 'Public', from: 'Visibility'
    
    click_button 'Create Cluster'
    
    expect(page).to have_text('Cluster was successfully created')
    expect(page).to have_text('My First Cluster')
    
    cluster = Cluster.last
    expect(cluster.name).to eq('My First Cluster')
    expect(cluster.created_by).to eq(user)
  end
  
  it 'shows validation errors' do
    visit new_cluster_path
    
    fill_in 'Name', with: ''
    click_button 'Create Cluster'
    
    expect(page).to have_text("Name can't be blank")
  end
  
  it 'updates cluster list in real-time', js: true do
    visit clusters_path
    
    # Simulate another user creating a cluster
    cluster = create(:cluster, name: 'New Cluster')
    
    # Turbo Stream should update the list
    expect(page).to have_text('New Cluster')
  end
end
```

#### Component Testing

**ViewComponent Spec**:
```ruby
# spec/components/clusters/cluster_card_component_spec.rb
require 'rails_helper'

RSpec.describe Clusters::ClusterCardComponent, type: :component do
  let(:cluster) { create(:cluster, name: 'Test Cluster', description: 'Test description') }
  
  it 'renders cluster name' do
    render_inline(described_class.new(cluster: cluster))
    
    expect(page).to have_text('Test Cluster')
  end
  
  it 'renders cluster description' do
    render_inline(described_class.new(cluster: cluster))
    
    expect(page).to have_text('Test description')
  end
  
  context 'when show_actions is true' do
    it 'renders edit link' do
      render_inline(described_class.new(cluster: cluster, show_actions: true))
      
      expect(page).to have_link('Edit', href: edit_cluster_path(cluster))
    end
  end
  
  context 'when show_actions is false' do
    it 'does not render edit link' do
      render_inline(described_class.new(cluster: cluster, show_actions: false))
      
      expect(page).not_to have_link('Edit')
    end
  end
end
```

#### Testing RLS Policies

**RLS Test Helper**:
```ruby
# spec/support/rls_helpers.rb
module RlsHelpers
  def with_rls_context(user_id)
    ActiveRecord::Base.connection.execute(
      "SET LOCAL app.current_user_id = '#{user_id}'"
    )
    yield
  ensure
    ActiveRecord::Base.connection.execute(
      "RESET app.current_user_id"
    )
  end
end

RSpec.configure do |config|
  config.include RlsHelpers, type: :model
end
```

**RLS Policy Test**:
```ruby
# spec/models/cluster_rls_spec.rb
require 'rails_helper'

RSpec.describe 'Cluster RLS Policies', type: :model do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:stranger) { create(:user) }
  let(:cluster) { create(:cluster, created_by: owner) }
  
  before do
    create(:cluster_member, cluster: cluster, user: owner, role: :owner)
    create(:cluster_member, cluster: cluster, user: member, role: :member)
  end
  
  describe 'SELECT policy' do
    it 'allows owner to see cluster' do
      with_rls_context(owner.id) do
        expect(Cluster.where(id: cluster.id).exists?).to be true
      end
    end
    
    it 'allows member to see cluster' do
      with_rls_context(member.id) do
        expect(Cluster.where(id: cluster.id).exists?).to be true
      end
    end
    
    it 'prevents stranger from seeing cluster' do
      with_rls_context(stranger.id) do
        expect(Cluster.where(id: cluster.id).exists?).to be false
      end
    end
  end
  
  describe 'DELETE policy' do
    it 'allows owner to delete cluster' do
      with_rls_context(owner.id) do
        expect { cluster.destroy }.to change(Cluster, :count).by(-1)
      end
    end
    
    it 'prevents member from deleting cluster' do
      with_rls_context(member.id) do
        expect { cluster.destroy }.not_to change(Cluster, :count)
      end
    end
  end
end
```

#### Test Coverage

**SimpleCov Configuration**:
```ruby
# spec/rails_helper.rb
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Components', 'app/components'
  add_group 'Services', 'app/services'
  
  minimum_coverage 80
end
```

### Recommendations for Universo Platformo Ruby

1. **Test Coverage**: Maintain 80%+ coverage for all packages
2. **Factory Bot**: Use factories for all test data generation
3. **Request Specs**: Test all API endpoints with comprehensive scenarios
4. **System Specs**: Test critical user journeys with Capybara
5. **Component Specs**: Unit test all ViewComponents
6. **RLS Testing**: Create helpers and test all RLS policies
7. **Performance**: Use `build_stubbed` when DB persistence not needed
8. **Test Organization**: Follow consistent directory structure

---

## 7. Comparison with Existing Plans

### Analysis of Current Implementation Plans

The existing plans in `specs/001-initial-ruby-setup/` already include many of the best practices discovered:

#### ✅ Already Captured

1. **Modular Package Architecture**: Documented with Rails Engine approach
2. **Row-Level Security**: Comprehensive RLS policies documented in `data-model.md`
3. **Role-Based Authorization**: Three-tier role system (owner/admin/member) specified
4. **API Standards**: RESTful patterns, query parameters, error responses documented
5. **Test Organization**: RSpec structure and patterns documented
6. **Supabase Integration**: Authentication and database setup covered

#### 🔄 Enhancements Needed

1. **Hotwire Details**: Add specific Turbo Frames/Streams patterns
2. **ViewComponent Library**: Expand on component organization and patterns
3. **Stimulus Controllers**: Add examples of common Stimulus patterns
4. **Testing Strategies**: Add more RLS testing examples
5. **Error Handling**: Expand error response standardization

---

## 8. Key Recommendations for Implementation

### Priority Enhancements

#### High Priority

1. **Create ViewComponent Library**
   - Build `app/components/universo/` for shared components
   - Implement Material Design with Tailwind CSS
   - Document component API and slots

2. **Implement Hotwire Patterns**
   - Use Turbo Frames for all CRUD operations
   - Implement Turbo Streams for real-time updates
   - Create Stimulus controllers for common interactions

3. **Standardize API Responses**
   - Implement consistent error response format
   - Add pagination metadata
   - Support filtering, sorting, field selection

4. **Enhance RLS Testing**
   - Create RLS test helpers
   - Write comprehensive RLS policy tests
   - Document RLS patterns for future packages

#### Medium Priority

1. **API Documentation**
   - Generate OpenAPI/Swagger specs
   - Provide API client examples
   - Document authentication flow

2. **Performance Optimization**
   - Add database indexes for RLS queries
   - Implement query result caching
   - Optimize N+1 queries

3. **Component Documentation**
   - Create component style guide
   - Provide usage examples
   - Document Material Design patterns

#### Low Priority

1. **Advanced Features**
   - Implement API rate limiting
   - Add webhook support
   - Create admin dashboard

---

## 9. Implementation Roadmap

### Phase 1: Foundation (Current)
- ✅ Repository structure
- ✅ Basic Rails setup
- ✅ Documentation framework
- 🔄 Complete initial package (clusters)

### Phase 2: Core Patterns (Next)
- Implement ViewComponent library
- Set up Hotwire patterns
- Standardize API responses
- Enhance RLS testing

### Phase 3: Feature Development
- Implement metaverses package
- Implement spaces package
- Create shared component library
- Build API documentation

### Phase 4: Polish & Optimization
- Performance optimization
- Advanced testing
- Security hardening
- Production deployment

---

## 10. Conclusion

The research confirms that the current Universo Platformo Ruby plans are well-aligned with 2024 Rails best practices. The project is on the right track with:

- **Rails Engines** for modularity
- **Supabase + RLS** for security
- **Hotwire** for modern frontend
- **ViewComponent** for reusable UI
- **RSpec** for comprehensive testing

### Key Takeaways

1. **Rails Engines are ideal**: The modular monolith approach fits our needs perfectly
2. **Hotwire is the future**: Embrace Turbo/Stimulus for reactive UIs without heavy JavaScript
3. **ViewComponent provides structure**: Component-based UI development is Rails' answer to React
4. **Supabase integration is solid**: RLS + JWT validation provides robust security
5. **Testing is paramount**: RSpec + FactoryBot + Capybara is the gold standard

### Next Steps

1. Review this document with the team
2. Identify any gaps in current specifications
3. Update relevant documentation as needed
4. Begin implementation following these patterns
5. Create reusable examples and templates

---

**Document Status**: ✅ COMPLETE  
**Last Updated**: 2025-11-17  
**Review Date**: 2025-12-17 (quarterly review recommended)
