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
- User can only access their own clusters (or clusters they are members of)
- Name must be unique per user

---

### 3. Clusters::ClusterMember

**Purpose**: Junction table with role-based access control for cluster membership

**Attributes**:
- `id` (bigint, primary key, auto-increment)
- `cluster_id` (bigint, not null, foreign key to clusters)
- `user_id` (UUID/bigint, not null, foreign key to users)
- `role` (string, not null, default: 'member')
- `comment` (text, nullable) - Optional note about the member
- `created_at` (timestamp, auto-generated)
- `updated_at` (timestamp, auto-generated)

**Validations**:
```ruby
validates :cluster_id, presence: true
validates :user_id, presence: true
validates :role, presence: true, inclusion: { in: %w[owner admin member] }
validates :user_id, uniqueness: { scope: :cluster_id, message: 'is already a member of this cluster' }

validate :at_least_one_owner_must_remain

private

def at_least_one_owner_must_remain
  if role_was == 'owner' && role != 'owner'
    remaining_owners = self.class.where(
      cluster_id: cluster_id,
      role: 'owner'
    ).where.not(id: id).count
    
    if remaining_owners < 1
      errors.add(:role, 'Cannot remove the last owner from a cluster')
    end
  end
end
```

**Associations**:
```ruby
belongs_to :cluster, class_name: 'Clusters::Cluster'
belongs_to :user
```

**Scopes**:
```ruby
scope :owners, -> { where(role: 'owner') }
scope :admins, -> { where(role: 'admin') }
scope :members, -> { where(role: 'member') }
scope :for_cluster, ->(cluster_id) { where(cluster_id: cluster_id) }
scope :for_user, ->(user_id) { where(user_id: user_id) }
```

**Indexes**:
- `index_cluster_members_on_cluster_id`
- `index_cluster_members_on_user_id`
- `index_cluster_members_on_cluster_id_and_user_id` (unique)
- `index_cluster_members_on_role`

**Business Rules**:
- Each user can be a member of a cluster only once
- At least one owner must exist for every cluster
- Role values are restricted to: 'owner', 'admin', 'member'
- Owner role has full permissions (view, edit, delete, manage members, transfer ownership)
- Admin role can manage members and edit but cannot delete or transfer ownership
- Member role can only view
- Comment field is optional for notes (e.g., "Technical lead", "External consultant")

**Role Permissions**:
```ruby
# In Clusters::Cluster model
include RoleBasedAccess

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
  membership = cluster_members.find_by(user: user)
  return false unless membership
  
  permissions = ROLE_PERMISSIONS[membership.role.to_sym]
  permissions[:"can_#{action}"] == true
end
```

**RLS Policy for ClusterMember**:
```sql
-- Users can see members of clusters they belong to
CREATE POLICY cluster_member_isolation_policy ON clusters.cluster_members
  USING (
    cluster_id IN (
      SELECT cluster_id 
      FROM clusters.cluster_members
      WHERE user_id = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );
```

---

### 4. Clusters::Domain

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

### 5. Clusters::Resource

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

## Row-Level Security (RLS) Policies

### Overview

PostgreSQL Row-Level Security (RLS) policies provide database-level data isolation. When enabled, queries automatically filter results based on the current user's JWT claims set in the session.

### RLS Policy Implementation

**Enable RLS on Tables**:
```sql
-- Enable RLS on all user-owned tables
ALTER TABLE clusters.clusters ENABLE ROW LEVEL SECURITY;
ALTER TABLE clusters.domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE clusters.resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE clusters.cluster_members ENABLE ROW LEVEL SECURITY;
```

**Cluster Isolation Policy**:
```sql
-- Users can only access clusters they are members of
CREATE POLICY cluster_isolation_policy ON clusters.clusters
  FOR ALL
  USING (
    id IN (
      SELECT cluster_id 
      FROM clusters.cluster_members 
      WHERE user_id = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );
```

**Domain Isolation Policy**:
```sql
-- Users can only access domains in their clusters
CREATE POLICY domain_isolation_policy ON clusters.domains
  FOR ALL
  USING (
    id IN (
      SELECT DISTINCT d.id 
      FROM clusters.domains d
      INNER JOIN clusters.cluster_domains cd ON cd.domain_id = d.id
      INNER JOIN clusters.cluster_members cm ON cm.cluster_id = cd.cluster_id
      WHERE cm.user_id = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );
```

**Resource Isolation Policy**:
```sql
-- Users can only access resources in their domains
CREATE POLICY resource_isolation_policy ON clusters.resources
  FOR ALL
  USING (
    id IN (
      SELECT DISTINCT r.id 
      FROM clusters.resources r
      INNER JOIN clusters.domain_resources dr ON dr.resource_id = r.id
      INNER JOIN clusters.cluster_domains cd ON cd.domain_id = dr.domain_id
      INNER JOIN clusters.cluster_members cm ON cm.cluster_id = cd.cluster_id
      WHERE cm.user_id = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );
```

**ClusterMember Isolation Policy**:
```sql
-- Users can see members of clusters they belong to
CREATE POLICY cluster_member_isolation_policy ON clusters.cluster_members
  FOR ALL
  USING (
    cluster_id IN (
      SELECT cluster_id 
      FROM clusters.cluster_members
      WHERE user_id = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );
```

### Policy Migration Example

```ruby
# db/migrate/YYYYMMDDHHMMSS_enable_rls_for_clusters.rb
class EnableRlsForClusters < ActiveRecord::Migration[7.0]
  def up
    # Enable RLS
    execute <<-SQL
      ALTER TABLE clusters.clusters ENABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.domains ENABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.resources ENABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.cluster_members ENABLE ROW LEVEL SECURITY;
    SQL
    
    # Create policies
    execute <<-SQL
      CREATE POLICY cluster_isolation_policy ON clusters.clusters
        FOR ALL
        USING (
          id IN (
            SELECT cluster_id 
            FROM clusters.cluster_members 
            WHERE user_id = current_setting('request.jwt.claims', true)::json->>'sub'
          )
        );
      
      CREATE POLICY domain_isolation_policy ON clusters.domains
        FOR ALL
        USING (
          id IN (
            SELECT DISTINCT d.id 
            FROM clusters.domains d
            INNER JOIN clusters.cluster_domains cd ON cd.domain_id = d.id
            INNER JOIN clusters.cluster_members cm ON cm.cluster_id = cd.cluster_id
            WHERE cm.user_id = current_setting('request.jwt.claims', true)::json->>'sub'
          )
        );
      
      -- Add other policies...
    SQL
  end
  
  def down
    # Drop policies
    execute <<-SQL
      DROP POLICY IF EXISTS cluster_isolation_policy ON clusters.clusters;
      DROP POLICY IF EXISTS domain_isolation_policy ON clusters.domains;
      -- Drop other policies...
    SQL
    
    # Disable RLS
    execute <<-SQL
      ALTER TABLE clusters.clusters DISABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.domains DISABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.resources DISABLE ROW LEVEL SECURITY;
      ALTER TABLE clusters.cluster_members DISABLE ROW LEVEL SECURITY;
    SQL
  end
end
```

### Testing RLS Policies

```ruby
# spec/support/rls_helpers.rb
module RlsHelpers
  def with_rls_context(user)
    jwt_claims = { sub: user.id, email: user.email }
    ActiveRecord::Base.connection.execute(
      "SET LOCAL request.jwt.claims = '#{jwt_claims.to_json}'"
    )
    yield
  ensure
    ActiveRecord::Base.connection.execute("RESET request.jwt.claims")
  end
end

# spec/models/clusters/cluster_spec.rb
RSpec.describe Clusters::Cluster, type: :model do
  describe 'RLS policies' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:cluster1) { create(:cluster, :with_owner, owner: user1) }
    let!(:cluster2) { create(:cluster, :with_owner, owner: user2) }
    
    it 'isolates clusters by user' do
      with_rls_context(user1) do
        expect(Clusters::Cluster.all).to include(cluster1)
        expect(Clusters::Cluster.all).not_to include(cluster2)
      end
      
      with_rls_context(user2) do
        expect(Clusters::Cluster.all).to include(cluster2)
        expect(Clusters::Cluster.all).not_to include(cluster1)
      end
    end
  end
end
```

### RLS Best Practices

1. **Always test policies**: Write comprehensive tests for all RLS policies
2. **Use indexes**: Ensure subqueries in policies are indexed for performance
3. **Document policies**: Add comments in migration explaining policy logic
4. **Monitor performance**: Use `EXPLAIN ANALYZE` to check policy overhead
5. **Fallback to app-level**: Keep application-level authorization as backup
6. **Test with real data**: Verify policies work with production-like data volumes

### Performance Considerations

- RLS policies add overhead to every query
- Index all columns used in policy subqueries
- Consider materialized views for complex policies
- Monitor query performance in production
- Use `pg_stat_statements` to identify slow RLS queries

---

**Data Model Status**: ✅ COMPLETE  
**RLS Policies**: ✅ DOCUMENTED  
**Ready for Contract Generation**: YES  
**Blockers**: NONE
