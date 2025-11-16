# Package README Template

Use this template when creating new packages in the `packages/` directory.

## Package Naming Convention

- **Frontend packages**: `<feature>-frt` (e.g., `clusters-frt`)
- **Backend packages**: `<feature>-srv` (e.g., `clusters-srv`)

## Package Structure

Each package must include:

1. **base/ directory**: Contains the core implementation
2. **README.md**: English documentation
3. **README-RU.md**: Russian documentation (exact copy with same line count)

## Creating a New Package

### For Rails Engine (Backend):

```bash
cd packages
rails plugin new feature-name-srv --mountable
cd feature-name-srv
mkdir -p base
```

### For Frontend Component Library:

```bash
cd packages
mkdir -p feature-name-frt/base
cd feature-name-frt
```

## Package README Template

Copy this template for your package README files:

---

# [Package Name]

[Brief description of the package purpose]

## Overview

[Detailed description of what this package provides]

## Installation

[Installation instructions]

## Usage

[Usage examples]

## API

[API documentation if applicable]

## Dependencies

[List of dependencies]

## Testing

```bash
# Run tests
bundle exec rspec
```

## Contributing

Follow the main repository guidelines for contributing.

## License

[License information]

---

## Important Notes

1. **Always maintain bilingual documentation**: Create both README.md and README-RU.md
2. **Line count must match**: English and Russian versions must have identical line counts
3. **Use base/ directory**: Always create a base/ subdirectory for core implementations
4. **Follow Rails conventions**: Use Rails naming and structure conventions
5. **Add tests**: Include comprehensive test coverage
