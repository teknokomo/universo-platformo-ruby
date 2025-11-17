# Data Model: Initial Platform Setup

**Feature**: Initial Platform Setup for Ruby Implementation  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This document defines the data models for the Universo Platformo Ruby implementation, focusing on the Clusters/Domains/Resources hierarchy as the reference implementation pattern.

---

## Entity Relationship Diagram

```
User (Supabase Auth)
  |
  | 1:N (owns)
  |
  ├── Cluster
  |     |
  |     | N:M (via ClusterDomain junction)
  |     |
  |     └── Domain
  |           |
  |           | N:M (via DomainResource junction)
  |           |
  |           └── Resource
```

---

## Core Entities

### 1. User (External - Supabase Auth)

**Source**: Managed by Supabase Auth service, referenced in Rails models

**Attributes**:
- `id` (UUID, primary key) - Supabase-generated user ID
- `email` (string) - User's email address
- `created_at` (timestamp) - Registration timestamp
- Managed entirely by Supabase Auth

**Rails Integration**:
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Virtual model for Supabase Auth users
  # Real user data comes from Supabase, we store only reference ID
  self.table_name = 'auth.users' # Reference Supabase schema
  
  has_many :clusters, class_name: 'Clusters::Cluster'
end
```

**Authorization Pattern**:
- JWT token contains user ID
- Rails middleware validates JWT and sets `current_user`
- All queries scoped to `current_user.id`

---

### 2. Clusters::Cluster

**Purpose**: Top-level organizational container

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `name` (string, not null, max 255 characters)
- `description` (text, nullable)
- `user_id` (bigint, not null, foreign key to users)
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)
- `discarded_at` (timestamp, nullable) - Soft delete

**Validations**:
```ruby
validates :name, presence: true, length: { maximum: 255 }
validates :user_id, presence: true
validates :name, uniqueness: { scope: :user_id, case_sensitive: false }
```

**Associations**:
```ruby
belongs_to :user
has_many :cluster_domains, dependent: :destroy
has_many :domains, through: :cluster_domains
```

**Scopes**:
```ruby
scope :for_user, ->(user_id) { where(user_id: user_id) }
scope :active, -> { where(discarded_at: nil) }
default_scope { active }
```

**Indexes**:
- `index_clusters_on_user_id`
- `index_clusters_on_name_and_user_id` (unique)
- `index_clusters_on_discarded_at`

**Business Rules**:
- Cannot be deleted if has associated domains
- User can only access their own clusters
- Name must be unique per user

---

### 3. Clusters::Domain

**Purpose**: Mid-level organizational unit within clusters

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `name` (string, not null, max 255 characters)
- `description` (text, nullable)
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)
- `discarded_at` (timestamp, nullable) - Soft delete

**Validations**:
```ruby
validates :name, presence: true, length: { maximum: 255 }
```

**Associations**:
```ruby
has_many :cluster_domains, dependent: :destroy
has_many :clusters, through: :cluster_domains
has_many :domain_resources, dependent: :destroy
has_many :resources, through: :domain_resources
```

**Scopes**:
```ruby
scope :active, -> { where(discarded_at: nil) }
scope :for_cluster, ->(cluster_id) { joins(:cluster_domains).where(cluster_domains: { cluster_id: cluster_id }) }
default_scope { active }
```

**Indexes**:
- `index_domains_on_name`
- `index_domains_on_discarded_at`

**Business Rules**:
- Can belong to multiple clusters (many-to-many)
- Cannot be deleted if has associated resources
- Inherits user access from parent cluster

---

### 4. Clusters::Resource

**Purpose**: Lowest-level entity containing actual data/configuration

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `name` (string, not null, max 255 characters)
- `resource_type` (string, nullable, max 100 characters)
- `configuration` (jsonb, default: {})
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)
- `discarded_at` (timestamp, nullable) - Soft delete

**Validations**:
```ruby
validates :name, presence: true, length: { maximum: 255 }
validates :resource_type, length: { maximum: 100 }, allow_nil: true
```

**Associations**:
```ruby
has_many :domain_resources, dependent: :destroy
has_many :domains, through: :domain_resources
```

**Scopes**:
```ruby
scope :active, -> { where(discarded_at: nil) }
scope :for_domain, ->(domain_id) { joins(:domain_resources).where(domain_resources: { domain_id: domain_id }) }
scope :by_type, ->(type) { where(resource_type: type) }
default_scope { active }
```

**Indexes**:
- `index_resources_on_name`
- `index_resources_on_resource_type`
- `index_resources_on_configuration` (GIN index for JSONB queries)
- `index_resources_on_discarded_at`

**Business Rules**:
- Can belong to multiple domains (many-to-many)
- Configuration stored as JSONB for flexibility
- Inherits user access from parent domain/cluster

---

## Junction Tables

### 5. Clusters::ClusterDomain

**Purpose**: Many-to-many relationship between Clusters and Domains

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `cluster_id` (bigint, not null, foreign key to clusters)
- `domain_id` (bigint, not null, foreign key to domains)
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)

**Validations**:
```ruby
validates :cluster_id, presence: true
validates :domain_id, presence: true
validates :domain_id, uniqueness: { scope: :cluster_id }
```

**Associations**:
```ruby
belongs_to :cluster
belongs_to :domain
```

**Indexes**:
- `index_cluster_domains_on_cluster_id`
- `index_cluster_domains_on_domain_id`
- `index_cluster_domains_on_cluster_and_domain` (unique: [:cluster_id, :domain_id])

**Business Rules**:
- Unique pairing (same domain can't be added to cluster twice)
- CASCADE delete when cluster or domain is hard-deleted

---

### 6. Clusters::DomainResource

**Purpose**: Many-to-many relationship between Domains and Resources

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `domain_id` (bigint, not null, foreign key to domains)
- `resource_id` (bigint, not null, foreign key to resources)
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)

**Validations**:
```ruby
validates :domain_id, presence: true
validates :resource_id, presence: true
validates :resource_id, uniqueness: { scope: :domain_id }
```

**Associations**:
```ruby
belongs_to :domain
belongs_to :resource
```

**Indexes**:
- `index_domain_resources_on_domain_id`
- `index_domain_resources_on_resource_id`
- `index_domain_resources_on_domain_and_resource` (unique: [:domain_id, :resource_id])

**Business Rules**:
- Unique pairing (same resource can't be added to domain twice)
- CASCADE delete when domain or resource is hard-deleted

---

## Database Schema (PostgreSQL)

### Migration: Create Clusters

```ruby
class CreateClustersClusters < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters_clusters do |t|
      t.string :name, null: false, limit: 255
      t.text :description
      t.bigint :user_id, null: false
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :clusters_clusters, :user_id
    add_index :clusters_clusters, [:name, :user_id], unique: true
    add_index :clusters_clusters, :discarded_at
    add_foreign_key :clusters_clusters, :users, column: :user_id
  end
end
```

### Migration: Create Domains

```ruby
class CreateClustersDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters_domains do |t|
      t.string :name, null: false, limit: 255
      t.text :description
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :clusters_domains, :name
    add_index :clusters_domains, :discarded_at
  end
end
```

### Migration: Create Resources

```ruby
class CreateClustersResources < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters_resources do |t|
      t.string :name, null: false, limit: 255
      t.string :resource_type, limit: 100
      t.jsonb :configuration, default: {}
      t.datetime :discarded_at
      t.timestamps
    end

    add_index :clusters_resources, :name
    add_index :clusters_resources, :resource_type
    add_index :clusters_resources, :configuration, using: :gin
    add_index :clusters_resources, :discarded_at
  end
end
```

### Migration: Create Junction Tables

```ruby
class CreateClustersJunctionTables < ActiveRecord::Migration[7.0]
  def change
    create_table :clusters_cluster_domains do |t|
      t.references :cluster, null: false, foreign_key: { to_table: :clusters_clusters }
      t.references :domain, null: false, foreign_key: { to_table: :clusters_domains }
      t.timestamps
    end
    
    add_index :clusters_cluster_domains, [:cluster_id, :domain_id], 
              unique: true, 
              name: 'index_cluster_domains_unique'

    create_table :clusters_domain_resources do |t|
      t.references :domain, null: false, foreign_key: { to_table: :clusters_domains }
      t.references :resource, null: false, foreign_key: { to_table: :clusters_resources }
      t.timestamps
    end
    
    add_index :clusters_domain_resources, [:domain_id, :resource_id], 
              unique: true, 
              name: 'index_domain_resources_unique'
  end
end
```

---

## Data Access Patterns

### Pattern 1: User's Clusters

```ruby
# Get all clusters for current user
current_user.clusters.order(created_at: :desc)

# Create cluster for user
current_user.clusters.create!(name: 'My Cluster', description: 'Description')
```

### Pattern 2: Cluster's Domains

```ruby
# Get all domains in a cluster
cluster.domains.includes(:resources).order(name: :asc)

# Add existing domain to cluster
cluster.domains << domain

# Create new domain and add to cluster
domain = Clusters::Domain.create!(name: 'New Domain')
cluster.domains << domain
```

### Pattern 3: Domain's Resources

```ruby
# Get all resources in a domain
domain.resources.order(created_at: :desc)

# Add existing resource to domain
domain.resources << resource

# Create new resource and add to domain
resource = Clusters::Resource.create!(
  name: 'New Resource',
  resource_type: 'API',
  configuration: { endpoint: 'https://api.example.com' }
)
domain.resources << resource
```

### Pattern 4: Authorization Check

```ruby
# Controller before_action
def authorize_cluster_access!
  @cluster = Clusters::Cluster.find(params[:id])
  unless @cluster.user_id == current_user.id
    render json: { error: 'Unauthorized' }, status: :forbidden
  end
end

# Scope all queries to current user
@clusters = current_user.clusters
```

### Pattern 5: Soft Delete

```ruby
# Soft delete (sets discarded_at)
cluster.discard

# Restore soft-deleted record
cluster.undiscard

# Permanent delete (hard delete)
cluster.destroy!

# Query including soft-deleted
Clusters::Cluster.with_discarded.where(user_id: current_user.id)
```

---

## Validation Rules

### Cluster Validations

- **name**: required, max 255 characters, unique per user
- **user_id**: required, must exist in users table
- **Cannot delete**: if `domains.any?`

### Domain Validations

- **name**: required, max 255 characters
- **Cannot delete**: if `resources.any?`

### Resource Validations

- **name**: required, max 255 characters
- **resource_type**: optional, max 100 characters
- **configuration**: must be valid JSON

### Junction Table Validations

- **ClusterDomain**: unique (cluster_id, domain_id) pair
- **DomainResource**: unique (domain_id, resource_id) pair

---

## JSONB Configuration Examples

### Resource Configuration Schema

```json
{
  "type": "api_endpoint",
  "config": {
    "endpoint": "https://api.example.com",
    "method": "GET",
    "headers": {
      "Authorization": "Bearer token"
    },
    "timeout": 30
  },
  "metadata": {
    "created_by": "user_id",
    "tags": ["production", "external"]
  }
}
```

### Querying JSONB

```ruby
# Find resources by configuration key
Clusters::Resource.where("configuration @> ?", { type: 'api_endpoint' }.to_json)

# Find by nested key
Clusters::Resource.where("configuration -> 'config' ->> 'method' = ?", "GET")

# Use JSONB operators
Clusters::Resource.where("configuration ? :key", key: 'endpoint')
```

---

## Performance Considerations

### Indexes

1. **Foreign Keys**: All foreign keys indexed for join performance
2. **Unique Constraints**: Composite indexes for uniqueness checks
3. **JSONB**: GIN index on configuration column for fast JSONB queries
4. **Soft Delete**: Index on `discarded_at` for filtered queries
5. **User Scope**: Index on `user_id` for user-scoped queries

### Query Optimization

```ruby
# Use includes to avoid N+1 queries
clusters = current_user.clusters
  .includes(domains: :resources)
  .order(created_at: :desc)

# Eager load associations
cluster = Clusters::Cluster
  .includes(:domains)
  .find(params[:id])

# Use exists? instead of any? for better performance
cluster.domains.exists? # Uses COUNT query
cluster.domains.any?    # Loads all records
```

### Connection Pooling

```yaml
# config/database.yml
production:
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  checkout_timeout: 5
```

---

## Data Model Patterns for Future Packages

This Clusters/Domains/Resources model serves as the **reference implementation** for future packages:

### Similar Three-Entity Hierarchies

**Metaverses Package**:
- Metaverse (top) → Section (middle) → Entity (bottom)
- Same junction table pattern
- Same soft delete implementation
- Same user isolation

**Profile Package** (simpler, two-entity):
- User → ProfileSettings
- Direct foreign key, no junction table
- Simpler validation rules

**Uniks Package** (extended hierarchy):
- User → Workspace → Project → Task → Subtask
- More levels but same pattern
- Consider UX complexity (breadcrumbs, navigation)

### Key Patterns to Reuse

1. **User Isolation**: All top-level entities belong to user
2. **Soft Delete**: `discarded_at` column on all main entities
3. **Junction Tables**: For many-to-many with uniqueness constraint
4. **JSONB Flexibility**: Use for varying configurations
5. **RESTful Structure**: Standard CRUD + relationship endpoints
6. **Authorization**: Before-action checks at controller level
7. **Validations**: Presence, uniqueness, prevent deletion with children

---

## Security Considerations

### Row-Level Security

While not using PostgreSQL RLS (Supabase feature), implement equivalent at Rails level:

```ruby
# All queries scoped to current user
class Clusters::ClustersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cluster, only: [:show, :update, :destroy]
  
  private
  
  def set_cluster
    @cluster = current_user.clusters.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Cluster not found' }, status: :not_found
  end
end
```

### SQL Injection Prevention

- **Always use parameterized queries** (ActiveRecord default)
- **Never interpolate user input** in SQL strings
- **Validate JSONB input** before saving

### Mass Assignment Protection

```ruby
# Use strong parameters
def cluster_params
  params.require(:cluster).permit(:name, :description)
end

# In controller
@cluster = current_user.clusters.create!(cluster_params)
```

---

**Data Model Status**: ✅ COMPLETE  
**Ready for Contract Generation**: YES  
**Blockers**: NONE
