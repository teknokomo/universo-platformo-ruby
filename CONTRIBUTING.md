# Contributing to Universo Platformo Ruby

Thank you for your interest in contributing to Universo Platformo Ruby! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and constructive in all interactions.

## Getting Started

1. **Read the documentation**
   - [README.md](README.md) / [README-RU.md](README-RU.md) - Project overview
   - [DEVELOPMENT.md](DEVELOPMENT.md) / [DEVELOPMENT-RU.md](DEVELOPMENT-RU.md) - Development guide
   - [Constitution](/.specify/memory/constitution.md) - Core principles
   - [GitHub Instructions](/.github/instructions/) - Workflow guidelines

2. **Set up your development environment**
   - Follow the instructions in [DEVELOPMENT.md](DEVELOPMENT.md)
   - Ensure all tests pass before making changes

## Contributing Workflow

### 1. Create an Issue

Before starting work, create an Issue following the guidelines in `.github/instructions/github-issues.md`:

- Write the Issue in English with Russian translation in a spoiler section
- Use the exact spoiler format: `<summary>In Russian</summary>`
- Apply appropriate labels (see `.github/instructions/github-labels.md`)
- Describe the problem or feature clearly
- Include acceptance criteria

Example Issue structure:

```markdown
# Update menu items

Description of the change in English...

<details>
<summary>In Russian</summary>

Описание изменения на русском...
</details>
```

### 2. Create a Feature Branch

```bash
git checkout -b feature/descriptive-name
# or
git checkout -b fix/bug-description
```

### 3. Make Your Changes

Follow these guidelines:

#### Code Style

- Follow Ruby on Rails conventions
- Use RuboCop for linting: `bundle exec rubocop`
- Maximum line length: 120 characters
- Use double quotes for strings
- Write clear, descriptive variable and method names

#### Testing

- Write tests for all new functionality
- Ensure all tests pass: `bundle exec rspec`
- Maintain test coverage above 90%
- Use FactoryBot for test fixtures
- Follow RSpec best practices

#### Documentation

- Update README files if adding features
- Add code comments for complex logic
- Document public APIs
- **Always maintain bilingual documentation** (English and Russian)
- **Ensure identical line counts** between language versions

#### Internationalization

- All user-facing text must use Rails I18n: `t('key')`
- Add translations to both `config/locales/en.yml` and `config/locales/ru.yml`
- Test with different locales

### 4. Commit Your Changes

Write clear commit messages:

```bash
git add .
git commit -m "Add feature: brief description"
```

Commit message guidelines:
- Use present tense ("Add feature" not "Added feature")
- Be descriptive but concise
- Reference Issue number if applicable

### 5. Run Quality Checks

Before pushing, run:

```bash
# Tests
bundle exec rspec

# Linter
bundle exec rubocop

# Security checks
bundle exec brakeman
bundle exec bundle-audit check --update
```

### 6. Push Your Branch

```bash
git push origin feature/descriptive-name
```

### 7. Create a Pull Request

Follow the guidelines in `.github/instructions/github-pr.md`:

- Title format: `GH{issue_number} Description`
- Include English description with Russian translation in spoiler
- Use the exact spoiler format: `<summary>In Russian</summary>`
- Link to the related Issue with `Fixes #123`
- Apply appropriate labels
- Include "Additional Work" section for supplementary changes

Example PR structure:

```markdown
Fixes #123

# Description

Description of changes in English...

## Changes Made

- Change 1
- Change 2

## Additional Work

- Documentation updates
- Test additions

## Testing

- [x] Manual testing completed
- [x] Automated tests pass
- [x] No breaking changes introduced

<details>
<summary>In Russian</summary>

Исправляет #123

# Описание

Описание изменений на русском...

## Внесенные изменения

- Изменение 1
- Изменение 2

## Дополнительная работа

- Обновления документации
- Добавление тестов

## Тестирование

- [x] Ручное тестирование завершено
- [x] Автоматические тесты проходят
- [x] Не внесено критических изменений
</details>
```

## Package Development

When creating new packages:

1. Follow the monorepo structure in `packages/`
2. Use naming convention: `<feature>-frt` for frontend, `<feature>-srv` for backend
3. Include `base/` directory in each package
4. Create README.md and README-RU.md for each package
5. See `packages/PACKAGE_README_TEMPLATE.md` for template

## Coding Standards

### Ruby/Rails Best Practices

- Follow MVC pattern strictly
- Use service objects for complex business logic
- Keep controllers thin (max 7 lines per action)
- Use concerns for shared behavior
- Prefer functional methods over imperative code
- Use database migrations for schema changes
- Add indexes for frequently queried columns

### Security

- Never commit sensitive data (credentials, keys)
- Use environment variables for configuration
- Validate all user input
- Use parameterized queries (ActiveRecord handles this)
- Run security checks: `bundle exec brakeman`

### Performance

- Use eager loading to avoid N+1 queries
- Add database indexes appropriately
- Cache expensive operations
- Monitor with rack-mini-profiler in development

## Documentation Standards

### README Files

- Must exist in both English (README.md) and Russian (README-RU.md)
- Must have identical structure and line count
- Include: overview, installation, usage, testing

### Code Comments

- Write in English
- Explain WHY, not WHAT
- Document complex algorithms
- Use YARD documentation format for public APIs

### Inline Documentation

```ruby
# Good
# Calculates weighted average based on priority to ensure
# high-priority items have greater influence on the result
def weighted_average(items)
  # implementation
end

# Bad
# Calculates average
def weighted_average(items)
  # implementation
end
```

## Testing Guidelines

### Test Coverage

- Aim for >90% code coverage
- Test all edge cases
- Test error handling
- Test validations and associations

### Test Structure

```ruby
RSpec.describe Cluster, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:domains) }
  end

  describe '#method_name' do
    context 'when condition' do
      it 'returns expected result' do
        # test implementation
      end
    end
  end
end
```

### Factory Usage

```ruby
# Create test data with factories
let(:cluster) { create(:cluster) }
let(:domain) { create(:domain, cluster: cluster) }
```

## Pull Request Review Process

1. Automated checks must pass (tests, linting, security)
2. Code review by maintainer
3. Address review comments
4. Approval from at least one maintainer
5. Merge to main branch

## Questions or Problems?

- Check [DEVELOPMENT.md](DEVELOPMENT.md) for development instructions
- Review existing Issues and Pull Requests
- Open a new Issue for questions
- Contact maintainers if needed

## Attribution

Contributors will be recognized in release notes and project documentation.

Thank you for contributing to Universo Platformo Ruby!
