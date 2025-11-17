# File Naming Conventions

This document defines the file naming conventions for the Universo Platformo Ruby monorepo.

## General Principles

File naming should be **consistent**, **predictable**, and **semantic**. Ruby and Rails have established conventions that we follow strictly.

## Ruby/Rails Files

### snake_case (Almost Everything)

**When to use**: All Ruby files (models, controllers, helpers, services, concerns, etc.)

**Rule of Thumb**: **Ruby code? → snake_case**

**Examples**:
```
✅ cluster.rb              - Model (singular)
✅ clusters_controller.rb  - Controller (plural)
✅ application_helper.rb   - Helper
✅ cluster_service.rb      - Service object
✅ authenticatable.rb      - Concern/module
✅ api_client.rb           - Utility class
```

**Rationale**:
- snake_case is the Ruby community standard
- Matches Ruby constant naming when converted to CamelCase
- File `cluster.rb` contains class `Cluster`
- File `clusters_controller.rb` contains class `ClustersController`

### Model Files (Singular)

**Convention**: Model files MUST use singular names

**Examples**:
```
✅ app/models/cluster.rb           - Defines Cluster model
✅ app/models/clusters/domain.rb   - Defines Clusters::Domain model
✅ app/models/user.rb              - Defines User model
```

**Rationale**:
- Rails convention: model file is singular, table name is plural
- Single model file represents a single record
- Matches ActiveRecord class naming

### Controller Files (Plural)

**Convention**: Controller files MUST use plural names

**Examples**:
```
✅ app/controllers/clusters_controller.rb           - ClustersController
✅ app/controllers/clusters/domains_controller.rb   - Clusters::DomainsController
✅ app/controllers/api/v1/resources_controller.rb   - Api::V1::ResourcesController
```

**Rationale**:
- Controllers handle collections of resources
- RESTful routes are plural: `/clusters`, `/domains`
- Rails convention: plural controller names

### View Files

**Convention**: Views follow `controller_name/action_name.html.erb` pattern

**Examples**:
```
✅ app/views/clusters/index.html.erb
✅ app/views/clusters/show.html.erb
✅ app/views/clusters/new.html.erb
✅ app/views/clusters/edit.html.erb
✅ app/views/clusters/_cluster.html.erb       - Partial (underscore prefix)
✅ app/views/layouts/application.html.erb
```

**Partials**:
- MUST start with underscore: `_form.html.erb`, `_card.html.erb`
- Used with `render` helper: `render 'form'` or `render partial: 'clusters/cluster'`

### ViewComponent Files

**Convention**: Component class and template in same directory

**Examples**:
```
✅ app/components/clusters/card_component.rb
✅ app/components/clusters/card_component.html.erb
✅ app/components/clusters/list_component.rb
✅ app/components/clusters/list_component.html.erb
```

**Class naming**: `CardComponent` (PascalCase class, snake_case file)

### Migration Files

**Convention**: Timestamp prefix + descriptive name

**Format**: `YYYYMMDDHHMMSS_description.rb`

**Examples**:
```
✅ db/migrate/20250116120000_create_clusters_clusters.rb
✅ db/migrate/20250116120100_create_clusters_domains.rb
✅ db/migrate/20250116120200_add_metadata_to_clusters_resources.rb
✅ db/migrate/20250116120300_create_clusters_junction_tables.rb
```

**Generation**: Use Rails generator to create with correct timestamp
```bash
rails generate migration CreateClustersClusters
rails generate migration AddMetadataToResource metadata:jsonb
```

### Test Files (RSpec)

**Convention**: Match file being tested with `_spec.rb` suffix

**Examples**:
```
✅ spec/models/cluster_spec.rb              - Tests app/models/cluster.rb
✅ spec/models/clusters/domain_spec.rb      - Tests app/models/clusters/domain.rb
✅ spec/controllers/clusters_controller_spec.rb
✅ spec/components/clusters/card_component_spec.rb
✅ spec/features/cluster_management_spec.rb - Integration test
```

**Feature specs**: Descriptive names for user journeys
- `cluster_management_spec.rb`
- `user_authentication_spec.rb`
- `domain_creation_spec.rb`

### Helper Files

**Convention**: Plural name matching controller

**Examples**:
```
✅ app/helpers/clusters_helper.rb           - ClustersHelper module
✅ app/helpers/application_helper.rb        - ApplicationHelper module
```

### Service Objects / POROs

**Convention**: Descriptive singular or verb-based names

**Examples**:
```
✅ app/services/cluster_creator.rb          - ClusterCreator class
✅ app/services/domain_associator.rb        - DomainAssociator class
✅ app/services/export_generator.rb         - ExportGenerator class
```

### Concerns / Modules

**Convention**: Adjective or trait names

**Examples**:
```
✅ app/models/concerns/authenticatable.rb   - Authenticatable module
✅ app/models/concerns/soft_deletable.rb    - SoftDeletable module
✅ app/controllers/concerns/authorization.rb - Authorization module
```

## Directory Names

### kebab-case (Package Directories)

**Convention**: All package and major directories use kebab-case

**Examples**:
```
✅ packages/clusters-srv/
✅ packages/clusters-frt/
✅ packages/space-builder-srv/
✅ packages/universo-template/
```

**Rationale**:
- Lowercase avoids case-sensitivity issues across filesystems
- Hyphens improve readability
- Standard in Node.js ecosystem (which we reference)
- Distinguishes packages from Rails app directories

### snake_case (Rails App Directories)

**Convention**: Standard Rails directories use snake_case

**Examples**:
```
✅ app/models/
✅ app/controllers/
✅ app/view_components/
✅ app/services/
✅ db/migrate/
✅ spec/features/
```

**Rationale**:
- Rails convention for app directories
- Consistent with Ruby file naming

## JavaScript/Stimulus Files

### camelCase (Stimulus Controllers)

**Convention**: Stimulus controller files use snake_case, but reference in HTML with kebab-case

**Examples**:
```
✅ app/javascript/controllers/cluster_form_controller.js   - File name
```

**HTML usage**:
```html
<div data-controller="cluster-form">  <!-- kebab-case in HTML -->
</div>
```

**Rationale**:
- File follows Ruby conventions (snake_case)
- HTML data attributes use kebab-case (HTML convention)
- Stimulus automatically converts between conventions

## CSS/SCSS Files

### snake_case

**Convention**: Stylesheet files use snake_case

**Examples**:
```
✅ app/assets/stylesheets/clusters.scss
✅ app/assets/stylesheets/components/card_component.scss
✅ app/assets/stylesheets/application.scss
```

## Configuration Files

### Various Conventions

Different config files follow different conventions based on ecosystem:

**Ruby configs** (snake_case):
```
✅ config/database.yml
✅ config/routes.rb
✅ config/application.rb
```

**Tool configs** (kebab-case or as required):
```
✅ .rubocop.yml
✅ .rspec
✅ docker-compose.yml
✅ Dockerfile
✅ Gemfile
```

## Special Files

### README Files

**Convention**: UPPERCASE with optional language suffix

**Examples**:
```
✅ README.md              - English version
✅ README-RU.md           - Russian version
✅ CONTRIBUTING.md
✅ CHANGELOG.md
✅ LICENSE.md
```

### Gemspec Files

**Convention**: Package name with .gemspec extension

**Examples**:
```
✅ clusters.gemspec
✅ universo-types.gemspec
✅ space-builder.gemspec
```

## Decision Tree

```
What are you naming?

├─ Ruby Model?
│   └─ singular_name.rb (Cluster → cluster.rb)
│
├─ Ruby Controller?
│   └─ plural_name_controller.rb (ClustersController → clusters_controller.rb)
│
├─ View File?
│   ├─ Partial? → _partial_name.html.erb
│   └─ Action? → action_name.html.erb
│
├─ ViewComponent?
│   ├─ component_name_component.rb
│   └─ component_name_component.html.erb
│
├─ Migration?
│   └─ YYYYMMDDHHMMSS_description.rb
│
├─ Test File?
│   └─ match_source_name_spec.rb
│
├─ Package Directory?
│   └─ kebab-case-name/
│
└─ Rails App Directory?
    └─ snake_case_name/
```

## Migration Guide

### When renaming files:

1. **Use Git rename** to preserve history:
   ```bash
   git mv app/models/Cluster.rb app/models/cluster.rb
   ```

2. **Update class references** if needed:
   - Ensure class name is still correct: `class Cluster < ApplicationRecord`
   - Check for any hard-coded string references

3. **Update requires/imports**:
   ```bash
   grep -r "require.*Cluster" .
   grep -r "Cluster" app/
   ```

4. **Run tests**:
   ```bash
   bundle exec rspec
   bundle exec rubocop
   ```

5. **Restart server** (Rails caches file names):
   ```bash
   rails restart
   ```

## Common Mistakes to Avoid

❌ **Wrong**:
```
Cluster.rb                    - Should be lowercase
ClustersController.rb         - Should be lowercase
cluster_controller.rb         - Should be plural
models/clusters.rb            - Should be singular
ClusterManagement_spec.rb     - Should be snake_case
_Form.html.erb                - Should be lowercase
20250116_create_clusters.rb   - Missing HHMMSS timestamp
```

✅ **Correct**:
```
cluster.rb
clusters_controller.rb
clusters_controller.rb
models/cluster.rb
cluster_management_spec.rb
_form.html.erb
20250116120000_create_clusters.rb
```

## Summary Table

| File Type | Convention | Location | Example |
|-----------|-----------|----------|---------|
| Model | **snake_case** (singular) | app/models/ | `cluster.rb` |
| Controller | **snake_case** (plural) + `_controller` | app/controllers/ | `clusters_controller.rb` |
| View | **snake_case** | app/views/ | `index.html.erb` |
| Partial | **_snake_case** | app/views/ | `_form.html.erb` |
| ViewComponent | **snake_case** + `_component` | app/components/ | `card_component.rb` |
| Migration | **YYYYMMDDHHMMSS_snake_case** | db/migrate/ | `20250116120000_create_clusters.rb` |
| Test | **snake_case** + `_spec` | spec/ | `cluster_spec.rb` |
| Helper | **snake_case** (plural) + `_helper` | app/helpers/ | `clusters_helper.rb` |
| Service | **snake_case** | app/services/ | `cluster_creator.rb` |
| Concern | **snake_case** | app/models/concerns/ | `soft_deletable.rb` |
| JavaScript | **snake_case** + `_controller` | app/javascript/ | `cluster_form_controller.js` |
| Stylesheet | **snake_case** | app/assets/stylesheets/ | `clusters.scss` |
| Package Directory | **kebab-case** | packages/ | `clusters-srv/` |
| Rails Directory | **snake_case** | app/ | `view_components/` |
| README | **UPPERCASE** + optional `-RU` | anywhere | `README.md`, `README-RU.md` |

## Enforcement

- **RuboCop**: Enforces Ruby naming conventions automatically
- **Rails Generators**: Produce correctly named files automatically
- **Code Review**: Reviewers should verify naming consistency
- **CI/CD**: Automated checks for file naming patterns

## References

- [Rails Naming Conventions](https://guides.rubyonrails.org/contributing_to_ruby_on_rails.html#follow-the-coding-conventions)
- [Ruby Style Guide](https://rubystyle.guide/)
- [RuboCop Default Configuration](https://github.com/rubocop/rubocop/blob/master/config/default.yml)

---

**Last Updated**: 2025-11-17  
**Status**: Active Standard
