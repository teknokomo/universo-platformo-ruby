# Feature Specification: Initial Platform Setup for Ruby Implementation

**Feature Branch**: `001-initial-ruby-setup`  
**Created**: 2025-11-16  
**Status**: Draft  
**Input**: User description: "Initialize Universo Platformo Ruby project with monorepo structure, packages, authentication, and Clusters functionality"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Repository Initialization (Priority: P1)

A developer clones the repository and can immediately understand the project structure, set up their development environment, and run the application successfully. The repository includes comprehensive bilingual documentation that explains the project's purpose, architecture, and setup steps.

**Why this priority**: Without proper repository setup, no development can begin. This is the foundation that enables all other work.

**Independent Test**: Can be fully tested by cloning the repository, following the README instructions, and successfully running the application. Delivers a working web application with proper documentation.

**Acceptance Scenarios**:

1. **Given** an empty repository, **When** documentation is created, **Then** README files exist in both English and Russian with identical structure and content
2. **Given** repository documentation, **When** a developer follows setup instructions, **Then** the development environment can be configured and the application runs
3. **Given** a need to track work, **When** GitHub is configured, **Then** appropriate issue labels exist following the project conventions

---

### User Story 2 - Monorepo Structure Setup (Priority: P1)

A developer can organize functionality into separate packages with clear separation between frontend and backend code. The monorepo structure supports multiple packages with shared dependencies, allowing independent development of different features while maintaining consistency.

**Why this priority**: The monorepo structure is the architectural foundation that determines how all future code will be organized. Must be established before any feature development.

**Independent Test**: Can be fully tested by creating a sample package with frontend and backend components, verifying dependency management works, and confirming the package structure follows conventions.

**Acceptance Scenarios**:

1. **Given** the need for a new feature, **When** a developer creates a package, **Then** the package follows the naming convention `<feature>-frt` for frontend and `<feature>-srv` for backend
2. **Given** a package structure, **When** examining the package, **Then** it contains a `base/` directory for core implementations
3. **Given** multiple packages, **When** managing dependencies, **Then** shared dependencies are managed efficiently across all packages

---

### User Story 3 - Database Integration (Priority: P2)

A developer can connect the application to a cloud database service for data persistence. The system stores and retrieves data reliably, with proper configuration for database authentication and access. The implementation allows for future expansion to support other database systems.

**Why this priority**: Database connectivity is essential for any data-driven feature, but can be implemented after basic project structure is in place.

**Independent Test**: Can be fully tested by configuring database credentials, establishing a connection, performing basic create/read/update/delete operations, and verifying data persistence.

**Acceptance Scenarios**:

1. **Given** database configuration, **When** the application starts, **Then** it successfully connects to the database instance
2. **Given** a database connection, **When** performing data operations, **Then** data is correctly persisted and retrieved
3. **Given** the need for different databases, **When** reviewing the implementation, **Then** the database layer is abstracted to allow future additions

---

### User Story 4 - Authentication System (Priority: P2)

A user can securely register, log in, and access protected features using the integrated authentication service. The system manages user sessions, provides appropriate feedback for authentication failures, and maintains security best practices.

**Why this priority**: Authentication is required before implementing user-specific features, but the basic application can run without it during initial development.

**Independent Test**: Can be fully tested by registering a new account, logging in with correct credentials, attempting login with incorrect credentials, and accessing protected routes.

**Acceptance Scenarios**:

1. **Given** a registration form, **When** a user submits valid credentials, **Then** a new account is created in the authentication service
2. **Given** an existing account, **When** the user logs in with correct credentials, **Then** a session is established and the user can access protected features
3. **Given** a logged-in user, **When** the session expires or user logs out, **Then** the user is redirected to the login page when accessing protected features

---

### User Story 5 - UI Framework Integration (Priority: P2)

A developer can create consistent, attractive user interfaces using a component library. Components follow Material Design principles and maintain visual consistency across the application.

**Why this priority**: UI framework is needed for frontend development but can be added after backend infrastructure is established.

**Independent Test**: Can be fully tested by creating a sample page with multiple UI components, verifying components render correctly, and confirming they follow Material Design patterns.

**Acceptance Scenarios**:

1. **Given** the need to create a form, **When** a developer uses the UI framework, **Then** form components are available and styled consistently
2. **Given** multiple pages, **When** viewing the application, **Then** all pages maintain visual consistency through shared UI components
3. **Given** responsive design needs, **When** viewing on different screen sizes, **Then** components adapt appropriately

---

### User Story 6 - Clusters Core Functionality (Priority: P3)

A user can manage clusters, which serve as the top-level organizational unit. Each cluster can contain domains, and each domain can contain resources. Users can create, view, update, and delete clusters with a clear hierarchical relationship between entities.

**Why this priority**: Clusters functionality represents the first business feature but requires all infrastructure (P1-P2) to be in place first.

**Independent Test**: Can be fully tested by creating a cluster, adding domains to it, adding resources to domains, and performing CRUD operations on all three entity types.

**Acceptance Scenarios**:

1. **Given** an authenticated user, **When** creating a new cluster, **Then** the cluster is saved and appears in the clusters list
2. **Given** an existing cluster, **When** viewing its details, **Then** all associated domains are displayed
3. **Given** a cluster with domains, **When** viewing a domain, **Then** all associated resources are displayed
4. **Given** a cluster/domain/resource, **When** performing updates or deletions, **Then** changes are persisted and reflected throughout the hierarchy

---

### Edge Cases

- What happens when a developer tries to create a package without following the naming convention?
- How does the system handle database connection failures during startup?
- What happens when authentication service credentials are invalid or expired?
- How does the system handle attempts to access protected routes without authentication?
- What happens when a user tries to delete a cluster that contains domains?
- How does the system handle concurrent updates to the same entity by multiple users?
- What happens when bilingual documentation files become out of sync?

## Requirements *(mandatory)*

### Functional Requirements

#### Repository Setup
- **FR-001**: System MUST include README files in both English and Russian with identical structure and line count
- **FR-002**: System MUST include GitHub issue labels following the conventions in `.github/instructions/github-labels.md`
- **FR-003**: System MUST include a `.gitignore` file appropriate for the chosen technology stack
- **FR-004**: Documentation MUST explain the project purpose, architecture, and setup instructions
- **FR-005**: System MUST include GitHub Issue templates for common issue types (bug, feature, enhancement)
- **FR-006**: System MUST include Pull Request templates with checklist for code review
- **FR-007**: System MUST include GitHub Actions workflows for CI/CD (tests, linting, security scanning)
- **FR-008**: System MUST include automated bilingual documentation verification to ensure line count parity

#### Monorepo Structure
- **FR-009**: System MUST organize code in a `packages/` directory using Rails Engines
- **FR-010**: System MUST separate frontend and backend code using `-frt` and `-srv` suffixes respectively
- **FR-011**: Each package MUST contain a `base/` directory for core implementations to support future alternative implementations
- **FR-012**: System MUST use Rails Engines for package management allowing efficient dependency sharing
- **FR-013**: System MUST allow packages to share common dependencies efficiently through Bundler
- **FR-014**: Each package MUST be structured to support future extraction as independent gem
- **FR-015**: System MUST document package creation patterns including when to use 3-entity hierarchy, variations, and extensions

#### Database Integration
- **FR-016**: System MUST support connection to Supabase PostgreSQL database
- **FR-017**: System MUST provide database configuration through environment variables
- **FR-018**: System MUST abstract database operations to allow future support for other database systems
- **FR-019**: System MUST handle database connection failures gracefully with appropriate error messages
- **FR-020**: System MUST use database migrations for all schema changes with proper version control

#### Authentication
- **FR-021**: System MUST integrate with Supabase authentication service
- **FR-022**: System MUST provide user registration functionality
- **FR-023**: System MUST provide user login functionality
- **FR-024**: System MUST maintain user sessions securely using industry-standard session management
- **FR-025**: System MUST protect routes that require authentication
- **FR-026**: System MUST provide appropriate feedback for authentication failures
- **FR-027**: System MUST support JWT tokens for API authentication

#### UI Framework
- **FR-028**: System MUST integrate Hotwire (Turbo + Stimulus) for reactive frontend
- **FR-029**: System MUST integrate ViewComponent for reusable UI components
- **FR-030**: System MUST integrate Tailwind CSS with Material Design theme
- **FR-031**: UI components MUST follow Material Design principles
- **FR-032**: System MUST provide consistent styling across all pages
- **FR-033**: System MUST support responsive design for different screen sizes

#### Clusters Functionality
- **FR-034**: System MUST provide create, read, update, and delete operations for Clusters entities
- **FR-035**: System MUST provide create, read, update, and delete operations for Domains entities
- **FR-036**: System MUST provide create, read, update, and delete operations for Resources entities
- **FR-037**: System MUST enforce hierarchical relationships: Clusters contain Domains, Domains contain Resources
- **FR-038**: System MUST prevent deletion of Clusters that contain Domains
- **FR-039**: System MUST prevent deletion of Domains that contain Resources
- **FR-040**: System MUST display hierarchical relationships in the user interface
- **FR-041**: Clusters package MUST serve as reference implementation for future entity packages

#### React Repository Tracking
- **FR-042**: System MUST include documentation for monitoring React repository updates
- **FR-043**: System MUST maintain feature parity tracking document comparing Ruby vs React implementations
- **FR-044**: System MUST document process for translating React features to Ruby implementation
- **FR-045**: System MUST document which React legacy patterns to avoid (Flowise code, unrefactored patterns)

#### Package Architecture Guidelines
- **FR-046**: System MUST document when to use full 3-entity hierarchy pattern (like Clusters)
- **FR-047**: System MUST document when to use partial entity hierarchy
- **FR-048**: System MUST document when to extend beyond 3-entity hierarchy
- **FR-049**: System MUST provide package creation template and checklist
- **FR-050**: System MUST document architectural extensibility for future features (Spaces/Canvases, node systems)

#### API Design Principles
- **FR-051**: System MUST follow RESTful endpoint naming conventions for all API routes
- **FR-052**: System MUST provide relationship management endpoints (e.g., `POST /clusters/:id/domains/:domain_id` to link entities)
- **FR-053**: System MUST implement idempotent operations for relationship management (linking same entities multiple times should not error)
- **FR-054**: System MUST return consistent error response format including error type, message, and validation details
- **FR-055**: System MUST validate all input parameters and return detailed validation errors with field-level feedback
- **FR-056**: System MUST implement API versioning strategy to support future changes without breaking existing clients
- **FR-057**: System MUST document all API endpoints in package README files with request/response examples

#### Security & Authorization
- **FR-058**: System MUST implement authorization guards at controller level to verify entity ownership before operations
- **FR-059**: System MUST enforce complete cluster-level data isolation (users cannot access other users' clusters)
- **FR-060**: System MUST prevent orphaned resources through mandatory foreign key associations
- **FR-061**: System MUST implement rate limiting on all API endpoints to prevent DoS attacks
- **FR-062**: System MUST log all authentication events, authorization failures, and suspicious activities
- **FR-063**: System MUST sanitize all user inputs to prevent SQL injection and XSS attacks
- **FR-064**: System MUST use parameterized queries for all database operations

#### Database Schema Patterns
- **FR-065**: System MUST use junction tables for many-to-many relationships (e.g., ClusterUser, DomainCluster, ResourceDomain)
- **FR-066**: System MUST enforce CASCADE delete at database level for hierarchical relationships
- **FR-067**: System MUST use UNIQUE constraints on junction table combinations to prevent duplicate associations
- **FR-068**: System MUST use JSONB columns for flexible metadata storage where appropriate
- **FR-069**: System MUST name migrations using timestamp format: `YYYYMMDDHHMMSS_description.rb`
- **FR-070**: System MUST include both up and down migration methods for all schema changes
- **FR-071**: System MUST add database indexes on foreign keys and frequently queried columns

#### Testing Requirements
- **FR-072**: System MUST achieve minimum 80% code coverage across all packages
- **FR-073**: System MUST include RSpec unit tests for all models with validation, association, and method tests
- **FR-074**: System MUST include controller tests for all endpoints covering success and error cases
- **FR-075**: System MUST include integration tests using Capybara for critical user journeys
- **FR-076**: System MUST use FactoryBot for test data generation with realistic fixtures
- **FR-077**: System MUST mock external service calls (Supabase, etc.) in unit tests
- **FR-078**: System MUST test authorization guards to ensure proper access control
- **FR-079**: System MUST test CASCADE delete behavior and referential integrity
- **FR-080**: System MUST name test files using `_spec.rb` suffix matching the file under test

#### File Naming Conventions
- **FR-081**: System MUST use snake_case for all Ruby files (models, controllers, helpers, etc.)
- **FR-082**: System MUST use singular names for model files (e.g., `cluster.rb`, not `clusters.rb`)
- **FR-083**: System MUST use plural names for controller files (e.g., `clusters_controller.rb`)
- **FR-084**: System MUST use kebab-case for directory names (e.g., `space-builder-srv/`)
- **FR-085**: System MUST document file naming conventions in `.github/FILE_NAMING.md`
- **FR-086**: System MUST follow Rails conventions for view file organization (controller_name/action_name.html.erb)

### Key Entities

- **Cluster**: Top-level organizational unit that groups related domains. Contains attributes like name, description, and creation timestamp. Has one-to-many relationship with Domains.

- **Domain**: Mid-level organizational unit within a cluster. Contains attributes like name, description, and belongs to a single Cluster. Has one-to-many relationship with Resources.

- **Resource**: Lowest-level entity within the hierarchy. Contains attributes like name, type, configuration, and belongs to a single Domain.

- **User**: Represents an authenticated user of the system. Contains credentials and profile information managed by the authentication service. Has permissions to perform operations on Clusters, Domains, and Resources.

## Package Architecture Patterns *(new section)*

### Three-Entity Hierarchy Pattern (Reference: Clusters)

The Clusters package demonstrates the standard three-entity hierarchy pattern that serves as a template for similar features:

**Structure:**
- **Top Level** (Cluster): Container entity with basic attributes (name, description, timestamps)
- **Middle Level** (Domain): Belongs to top-level, can contain bottom-level entities
- **Bottom Level** (Resource): Belongs to middle-level, contains specific data/configuration

**When to Use Full Pattern:**
- Feature requires clear organizational hierarchy
- Users need to group related items at multiple levels
- Each level has distinct purpose and attributes
- Examples: Clusters/Domains/Resources, Metaverses/Sections/Entities

**Implementation Guidelines:**
- Each level is a separate ActiveRecord model
- Use `has_many :through` for cross-level relationships if needed
- Implement soft delete with dependent: :destroy callbacks
- Prevent deletion of parent entities with children
- Use Rails nested routes for hierarchical URLs
- Create separate controllers for each entity level
- ViewComponents for consistent list/form rendering

### Pattern Variations

**Two-Entity Hierarchy:**
- When middle level is unnecessary
- Direct parent-child relationship
- Example: Categories/Items

**Extended Hierarchy (4+ levels):**
- When additional organizational depth needed
- Example: Uniks may have Users/Workspaces/Projects/Tasks/Subtasks
- Consider UX complexity - deep hierarchies can confuse users
- Use breadcrumb navigation and clear visual hierarchy

**Single Entity with Tags/Categories:**
- When hierarchy is flexible or user-defined
- Use acts-as-taggable-on gem or similar
- Example: Notes with tags

### Future Architectural Extensibility

**Node-Based Systems (for Spaces/Canvases):**
The architecture must support future node-based visual programming features:

- **Node Entity**: Represents a single operation/function in a graph
- **Edge Entity**: Represents connections between nodes
- **Canvas Entity**: Container for node graphs
- **Node Types**: LangChain operations, UPDL custom nodes, data transformations
- **Execution Engine**: Processes node graphs (future implementation)

**Preparation Requirements:**
- Package structure must support complex entity relationships
- Database schema should allow JSON/JSONB for node configurations
- Frontend must support dynamic component loading
- Consider using Stimulus controllers for interactive node editing

**Integration Points:**
- Nodes can reference Clusters, Domains, Resources
- Canvases belong to Spaces (future entity)
- Results can be stored in Resources or separate output entities

### Package Creation Checklist

When creating a new package following an existing pattern:

1. **Planning Phase:**
   - [ ] Identify which pattern to use (3-entity, 2-entity, extended, or custom)
   - [ ] Define entity relationships and attributes
   - [ ] Review similar packages for consistency
   - [ ] Check if package needs both -frt and -srv or just one

2. **Structure Phase:**
   - [ ] Create package directory: `packages/feature-name-srv/`
   - [ ] Create `base/` subdirectory
   - [ ] Generate Rails Engine: `rails plugin new --mountable`
   - [ ] Add to main application Gemfile with path dependency

3. **Implementation Phase:**
   - [ ] Generate models with migrations
   - [ ] Add validations and associations
   - [ ] Generate controllers following REST conventions
   - [ ] Create ViewComponents for UI elements
   - [ ] Add RSpec tests (models, controllers, features)
   - [ ] Implement soft delete if hierarchical

4. **Documentation Phase:**
   - [ ] Create README.md (English)
   - [ ] Create README-RU.md (Russian, identical structure)
   - [ ] Verify line count matches between versions
   - [ ] Document API endpoints if applicable
   - [ ] Add inline code comments for complex logic

5. **Integration Phase:**
   - [ ] Mount engine routes in main application
   - [ ] Add navigation menu items
   - [ ] Test integration with authentication
   - [ ] Verify responsive design
   - [ ] Run full test suite

## Rails Engine Package Structure Template *(new section)*

### Standard Server Package Structure

Each `-srv` package follows this Rails Engine structure:

```
packages/feature-name-srv/
└── base/
    ├── app/
    │   ├── models/
    │   │   └── feature_name/           # Namespaced models
    │   │       ├── entity_one.rb
    │   │       ├── entity_two.rb
    │   │       └── junction_table.rb
    │   ├── controllers/
    │   │   └── feature_name/           # Namespaced controllers
    │   │       ├── application_controller.rb
    │   │       ├── entity_ones_controller.rb
    │   │       └── entity_twos_controller.rb
    │   ├── views/
    │   │   └── feature_name/           # Namespaced views
    │   │       ├── entity_ones/
    │   │       │   ├── index.html.erb
    │   │       │   ├── show.html.erb
    │   │       │   ├── new.html.erb
    │   │       │   └── edit.html.erb
    │   │       └── entity_twos/
    │   │           └── ...
    │   └── components/                 # ViewComponents
    │       └── feature_name/
    │           ├── entity_card_component.rb
    │           ├── entity_card_component.html.erb
    │           └── entity_form_component.rb
    ├── config/
    │   └── routes.rb                   # Engine routes
    ├── db/
    │   └── migrate/                    # Migrations
    │       ├── YYYYMMDDHHMMSS_create_feature_name_entity_ones.rb
    │       ├── YYYYMMDDHHMMSS_create_feature_name_entity_twos.rb
    │       └── YYYYMMDDHHMMSS_create_feature_name_junction_tables.rb
    ├── lib/
    │   ├── feature_name/
    │   │   ├── engine.rb               # Engine configuration
    │   │   └── version.rb
    │   └── feature_name.rb             # Main module
    ├── spec/
    │   ├── models/
    │   │   └── feature_name/
    │   │       ├── entity_one_spec.rb
    │   │       └── entity_two_spec.rb
    │   ├── controllers/
    │   │   └── feature_name/
    │   │       ├── entity_ones_controller_spec.rb
    │   │       └── entity_twos_controller_spec.rb
    │   ├── features/                   # Integration tests
    │   │   └── entity_management_spec.rb
    │   ├── factories/
    │   │   └── feature_name/
    │   │       ├── entity_ones.rb
    │   │       └── entity_twos.rb
    │   └── spec_helper.rb
    ├── Gemfile
    ├── feature_name.gemspec
    ├── README.md
    ├── README-RU.md
    └── Rakefile
```

### Standard Frontend Package Structure

Each `-frt` package contains ViewComponents and Stimulus controllers:

```
packages/feature-name-frt/
└── base/
    ├── app/
    │   ├── components/
    │   │   └── feature_name/
    │   │       ├── list_component.rb
    │   │       ├── list_component.html.erb
    │   │       ├── card_component.rb
    │   │       └── card_component.html.erb
    │   ├── javascript/
    │   │   └── feature_name/
    │   │       └── controllers/        # Stimulus controllers
    │   │           ├── list_controller.js
    │   │           └── form_controller.js
    │   └── assets/
    │       └── stylesheets/
    │           └── feature_name/
    │               └── components.css
    ├── lib/
    │   ├── feature_name/
    │   │   ├── engine.rb
    │   │   └── version.rb
    │   └── feature_name.rb
    ├── spec/
    │   └── components/
    │       └── feature_name/
    │           ├── list_component_spec.rb
    │           └── card_component_spec.rb
    ├── Gemfile
    ├── feature_name.gemspec
    ├── README.md
    ├── README-RU.md
    └── Rakefile
```

### Key Structure Principles

**Namespacing:**
- All models, controllers, views in packages MUST be namespaced with package name
- Prevents naming conflicts between packages
- Example: `Clusters::Domain` not just `Domain`

**Engine Configuration:**
- Each engine has `lib/{feature_name}/engine.rb` configuring Rails engine behavior
- Mounts at specific path in main application
- Can define isolated namespace or shared namespace

**Migrations:**
- Migrations live in package's `db/migrate/` directory
- Main application discovers and runs all package migrations
- Migration generator: `rails g migration AddFieldToTable --scope=feature_name`

**Testing:**
- Tests organized by type: models/, controllers/, features/
- Factories in spec/factories/ with package namespace
- Feature specs test full user journeys across UI

**Dependencies:**
- Gemspec defines dependencies for the package
- Main application Gemfile includes: `gem 'feature_name', path: 'packages/feature-name-srv/base'`
- Bundler resolves shared dependencies

### Example: Clusters Package Structure

```
packages/clusters-srv/
└── base/
    ├── app/
    │   ├── models/
    │   │   └── clusters/
    │   │       ├── cluster.rb
    │   │       ├── domain.rb
    │   │       ├── resource.rb
    │   │       ├── cluster_user.rb         # Junction: Cluster ↔ User
    │   │       ├── domain_cluster.rb       # Junction: Domain ↔ Cluster
    │   │       └── resource_domain.rb      # Junction: Resource ↔ Domain
    │   ├── controllers/
    │   │   └── clusters/
    │   │       ├── application_controller.rb
    │   │       ├── clusters_controller.rb
    │   │       ├── domains_controller.rb
    │   │       └── resources_controller.rb
    │   └── views/...
    ├── config/
    │   └── routes.rb                       # namespace :clusters do ... end
    ├── db/
    │   └── migrate/
    │       ├── 20250116120000_create_clusters_clusters.rb
    │       ├── 20250116120100_create_clusters_domains.rb
    │       ├── 20250116120200_create_clusters_resources.rb
    │       └── 20250116120300_create_clusters_junction_tables.rb
    └── spec/...
```

### README Template Structure

Each package README (both English and Russian) MUST contain:

1. **Package Information Header**
   - Package name, version, status
   - Architecture type (Modern Rails Engine)
   - Key features summary

2. **Key Features Section**
   - Entity hierarchy description
   - Data isolation and security features
   - Database integration details

3. **Installation Section**
   - How to install from workspace
   - Build/test commands

4. **Usage Section**
   - How to mount engine in main app
   - Basic code examples

5. **API Reference (for -srv packages)**
   - All endpoints with HTTP methods
   - Request/response examples
   - Error responses

6. **Architecture Section**
   - Entity relationships diagram or description
   - Key design decisions
   - Integration points

7. **Testing Section**
   - How to run tests
   - Coverage requirements
   - Key test scenarios

8. **Contributing Section**
   - How to add new features
   - Code style guidelines
   - PR requirements

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Developer can clone repository and have application running locally within 15 minutes following README instructions
- **SC-002**: All documentation files maintain 100% line count parity between English and Russian versions
- **SC-003**: System successfully authenticates users and maintains sessions for the duration of their interaction
- **SC-004**: Users can complete cluster creation including adding domains and resources within 3 minutes
- **SC-005**: Application handles 100 concurrent users performing CRUD operations without performance degradation
- **SC-006**: All pages load and render completely within 2 seconds under normal conditions
- **SC-007**: Developer can create a new feature package following the established structure within 10 minutes
- **SC-008**: System maintains database connectivity with 99.9% uptime during operation
- **SC-009**: Authentication success rate exceeds 99% for valid credentials
- **SC-010**: UI components maintain visual consistency score of 95% across all pages (measured by design system compliance)
- **SC-011**: Zero critical security vulnerabilities in authentication and database access layers
- **SC-012**: Responsive design functions correctly across desktop (1920px), tablet (768px), and mobile (375px) viewports
- **SC-013**: Bilingual documentation line count verification passes for all README pairs
- **SC-014**: All CI/CD checks pass (tests, linting, security scanning) before merge
- **SC-015**: Package creation following checklist takes less than 2 hours from start to fully tested

## React Repository Tracking and Feature Parity *(new section)*

### Monitoring Strategy

**Weekly Review Process:**
1. Check React repository for new commits and pull requests
2. Review React Issues for planned features and bug fixes
3. Identify features that should be ported to Ruby version
4. Document decisions in tracking document

**Tracking Document Location:**
- `docs/FEATURE_PARITY.md` (create when first needed)
- Sections: Implemented, In Progress, Planned, Not Applicable

**What to Monitor:**
- New packages added to React version
- Changes to existing package functionality
- UI/UX improvements
- Bug fixes that apply to both implementations
- Architecture changes that affect both versions

### Feature Translation Process

**When a React Feature is Identified for Porting:**

1. **Analysis Phase:**
   - Study React implementation (code, documentation, tests)
   - Identify core functionality vs React-specific implementation
   - Note any Flowise legacy code to avoid
   - Document Ruby equivalent technologies

2. **Specification Phase:**
   - Create feature specification using `/speckit.specify`
   - Reference React feature but focus on WHAT not HOW
   - Adapt for Rails conventions and patterns
   - Include bilingual documentation requirements

3. **Implementation Phase:**
   - Follow this project's package patterns
   - Use Rails best practices, not React patterns
   - Ensure test coverage matches or exceeds React version
   - Document deviations and reasons

4. **Verification Phase:**
   - Compare functionality with React version
   - Verify feature parity (not code parity)
   - Update tracking document
   - Cross-reference Issue numbers between repos if applicable

### Legacy Code Avoidance

**DO NOT Port from React Version:**

1. **Flowise Legacy Code:**
   - Unrefactored code from original Flowise project
   - Look for TODO comments mentioning Flowise
   - Check git history - if code predates Universo Platformo, be cautious

2. **Architectural Debt:**
   - Hard-coded configurations that should be environment variables
   - Monolithic components that should be split
   - Missing tests or test coverage gaps
   - Inconsistent naming conventions

3. **React-Specific Workarounds:**
   - Solutions to React limitations that don't apply to Rails
   - State management complexity unnecessary in server-rendered apps
   - Client-side routing workarounds (Rails handles routing natively)

**How to Identify Legacy Code:**
- Check React repo git blame for file age
- Look for comments mentioning "Flowise", "TODO: refactor", "legacy"
- Compare with newer packages to see pattern differences
- When in doubt, ask or design from scratch following Rails patterns

### Feature Parity vs Code Parity

**Remember:**
- **Feature Parity**: Same functionality, user experience, capabilities ✅
- **Code Parity**: Same code structure, libraries, patterns ❌

**Goal is Feature Parity, NOT Code Parity:**
- Ruby version should use Ruby/Rails best practices
- UI may differ if Rails approach is better
- Backend architecture will be different (Rails vs Express)
- Database schema may differ while providing same functionality

**Example:**
- React: Uses React Router, React Context, Redux
- Ruby: Uses Rails routing, sessions, ViewComponents
- Both: Provide same user features and experience

## Future Package Roadmap *(new section)*

Based on the React repository analysis, the following packages should be implemented in future phases following the Clusters pattern:

### Core Business Packages (High Priority)

**Metaverses Package** (`metaverses-frt/srv`)
- Three-entity hierarchy: Metaverse → Section → Entity
- Similar to Clusters but focused on virtual world organization
- Implements same CRUD + relationship management patterns
- Priority: Implement after Clusters as second reference implementation

**Uniks Package** (`uniks-frt/srv`)
- Extended hierarchy example (4+ levels possible)
- May include: User → Workspace → Project → Task → Subtask structure
- Demonstrates when to extend beyond 3-entity pattern
- Priority: Medium (after Metaverses)

**Profile Package** (`profile-frt/srv`)
- User profile management
- Two-entity pattern: User → ProfileSettings
- Integration with authentication system
- Priority: High (needed for user management)

### Feature Enhancement Packages (Medium Priority)

**Spaces Package** (`spaces-frt/srv`)
- 3D environment management
- Foundation for visual builder functionality
- Integration with Metaverses
- Priority: Medium (requires Metaverses first)

**Space Builder Package** (`space-builder-frt/srv`)
- Visual editor for creating 3D spaces
- Node-based interface (future node system foundation)
- Heavy frontend component package
- Priority: Medium (requires Spaces)

**Publish Package** (`publish-frt/srv`)
- Publication and deployment system
- Allows exporting/deploying created content
- Integration with all entity types
- Priority: Medium

**Analytics Package** (`analytics-frt`)
- Quiz and interaction analytics
- Data visualization components
- Read-heavy operations
- Priority: Low (nice-to-have)

### Shared Utility Packages (Should Be Created Early)

**Universo Types** (`universo-types`)
- Shared Ruby concerns and modules
- Common interfaces and abstractions
- Type definitions and validators
- Priority: High (create alongside Clusters)

**Universo Utils** (`universo-utils`)
- Shared utility functions
- Common helpers and extensions
- String, date, validation utilities
- Priority: High (create alongside Clusters)

**Universo API Client** (`universo-api-client`)
- Standardized HTTP client for internal package communication
- Request/response handling
- Error handling and retries
- Priority: Medium

**Universo I18n** (`universo-i18n`)
- Internationalization utilities
- Language switching helpers
- Translation management
- Priority: Medium (beyond English/Russian support)

**Universo Template** (`universo-template`)
- Shared ViewComponent library
- Material Design Rails components
- Hotwire + Stimulus integrations
- Priority: High (create alongside UI framework integration)

### Advanced Packages (Future/Research)

**UPDL Package** (`updl`)
- Universal Platform Description Language
- Node system for describing scenes and logic
- Foundation for visual programming features
- Priority: Low (research phase, complex)

**Multiplayer Package** (`multiplayer-srv`)
- Real-time multiplayer functionality
- WebSocket/ActionCable integration
- Game state synchronization
- Priority: Low (advanced feature)

### Implementation Sequence Recommendation

**Phase 1 - Foundation** (Current Sprint):
1. Repository setup
2. Monorepo structure
3. Database integration
4. Authentication
5. UI framework
6. Clusters package (reference implementation)
7. Universo Types
8. Universo Utils
9. Universo Template

**Phase 2 - Core Business Features**:
1. Profile package
2. Metaverses package (second reference)
3. Universo API Client

**Phase 3 - Extended Features**:
1. Uniks package (extended hierarchy)
2. Spaces package
3. Space Builder package
4. Publish package

**Phase 4 - Advanced Features**:
1. Analytics package
2. Universo I18n (additional languages)
3. UPDL package (research and prototype)
4. Multiplayer package (if needed)

### Package Creation Strategy

For each new package:
1. Review React implementation for feature understanding (not for code copying)
2. Create spec using `/speckit.specify` adapted for Rails patterns
3. Follow Package Creation Checklist from this spec
4. Use Clusters or Metaverses as template depending on complexity
5. Ensure bilingual documentation from start
6. Add to Feature Parity tracking document

### Notes

- Not all React packages need Ruby equivalents (some are React-specific workarounds)
- Focus on feature parity, not code parity
- Avoid porting Flowise legacy code patterns
- Each package should be independently testable and deployable
- Maintain consistent patterns across all packages for developer familiarity

## Assumptions

### Technology Stack (Definitive Choices)
1. **Programming Language**: Ruby 3.2+ will be used as the primary language
2. **Web Framework**: Rails 7.0+ will be used for web application functionality
3. **Monorepo Tool**: Rails Engines for package management with Bundler for dependency management
   - Each package will be a Rails Engine in `packages/` directory
   - Engines provide proper isolation and can be extracted to separate gems later
4. **Database**: PostgreSQL as the underlying database due to cloud service compatibility
5. **Database Service**: Supabase will be used as the cloud database and authentication provider
6. **UI Framework**: 
   - Hotwire (Turbo + Stimulus) for reactive frontend
   - ViewComponent for reusable UI components
   - Tailwind CSS with custom Material Design theme for styling
7. **Authentication**: 
   - Supabase Auth for authentication backend
   - Devise or custom session management for Rails integration
   - JWT tokens for API authentication
8. **Deployment**: Production deployment will be containerized (Docker) for consistency

### Project Conventions
9. **Development Environment**: Developers are using macOS or Linux development environments
10. **Package Naming**: English names for packages with Russian translations in documentation only
11. **Version Control**: Git workflow with feature branches and pull requests as described in repository instructions
12. **Data Deletion**: Soft deletion rather than hard deletion for entities with relationships to preserve data integrity
13. **Code Quality**: RuboCop for style enforcement, Brakeman for security scanning, SimpleCov for coverage (minimum 80%)
14. **Testing**: RSpec for all tests, FactoryBot for fixtures, Capybara for integration tests

## Dependencies

1. **External Reference**: Universo Platformo React repository (https://github.com/teknokomo/universo-platformo-react) serves as the conceptual reference for architecture and feature set
   - **Monitoring Strategy**: Weekly review of React repo for new features and updates
   - **Feature Parity**: Maintain tracking document of implemented vs pending features
   - **Legacy Code Awareness**: Do NOT port Flowise legacy code that hasn't been refactored in React version
2. **Cloud Services**: Cloud database and authentication service account setup required before data persistence and user authentication can function
3. **Language Runtime**: Ruby 3.2+ and Rails 7.0+ installation required
4. **UI Library**: Hotwire, ViewComponent, and Tailwind CSS integration required
5. **Documentation Tools**: Markdown rendering for README files with line count verification tooling
6. **GitHub Configuration**: Repository access to create labels, issue templates, PR templates, and configure CI/CD workflows
7. **Development Tools**: Docker for containerization, Git for version control, IDE with Ruby/Rails support

## Scope Boundaries

### In Scope
- Repository initialization with proper documentation structure
- Monorepo setup with Rails Engines package organization
- GitHub repository configuration:
  - Issue templates creation
  - Pull request templates creation
  - GitHub Actions CI/CD pipeline setup
  - Security scanning (RuboCop, Brakeman, Bundler-audit) integration
  - Automated testing workflow
- Supabase database connection configuration
- Supabase authentication integration
- Hotwire + ViewComponent + Tailwind CSS framework integration
- Core Clusters/Domains/Resources CRUD functionality as reference pattern
- Package architecture documentation (when to use 3-entity pattern, variations)
- Bilingual (English/Russian) documentation with verification process
- Development environment setup documentation
- Migration preparation (Engine structure supports future gem extraction)

### Out of Scope (Future Features)
- Additional database system integrations (MySQL, MongoDB, etc.) - framework should be extensible but implementations are future work
- Advanced Clusters features beyond basic CRUD (covered in separate feature specs)
- Other entity types (Metaverses/Sections/Entities, Uniks with extended hierarchy) - these follow same pattern and will be added in separate features
- Spaces/Canvases functionality with node graphs for LangChain and UPDL nodes (architectural hints provided, full implementation is future work)
- Production deployment automation and infrastructure as code
- Advanced authorization beyond basic authentication (roles, permissions, policies)
- API documentation with OpenAPI/Swagger
- External API access for third-party integrations
- Internationalization beyond English/Russian (additional languages are future work)
- Performance optimization beyond basic requirements (caching, CDN, database optimization)
- Comprehensive monitoring and logging infrastructure (APM, error tracking)
- Advanced search and filtering capabilities (Elasticsearch, full-text search)

### Must NOT Implement (Explicitly Excluded)
- **docs/ folder**: Documentation will be in a separate repository (docs.universo.pro)
- **AI agent configuration files**: User will create these manually as needed (.github/agents/ exists but no custom rules)
- **React implementation flaws**: Do not copy over unrefactored code patterns from React version
- **Flowise legacy code**: React version still contains legacy Flowise code - do NOT port this
- **Hard-coded configurations**: All configuration must be through environment variables or database
- **Monolithic architecture**: Maintain package separation even if harder initially
