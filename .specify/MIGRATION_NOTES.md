# Spec Kit Migration Notes

**Date**: 2024-11-24  
**Version**: 1.0.0

## Overview

This document describes the migration of the Spec Kit documentation structure from the old `specs/` directory to the standardized `.specify/specs/` location, aligning with the Spec Kit framework best practices.

## Changes Made

### Directory Structure

**Before:**
```
universo-platformo-ruby/
├── specs/
│   └── 001-initial-ruby-setup/
│       ├── spec.md
│       ├── plan.md
│       ├── tasks.md
│       └── ...
├── .specify/
│   ├── memory/
│   ├── scripts/
│   └── templates/
```

**After:**
```
universo-platformo-ruby/
├── .specify/
│   ├── memory/
│   │   └── constitution.md
│   ├── scripts/
│   │   └── bash/
│   │       ├── check-prerequisites.sh
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       └── update-agent-context.sh
│   ├── specs/
│   │   └── 001-initial-ruby-setup/
│   │       ├── spec.md
│   │       ├── plan.md
│   │       ├── tasks.md
│   │       └── ...
│   └── templates/
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── ...
```

### Files Updated

1. **`.specify/scripts/bash/common.sh`**
   - Updated `get_feature_dir()` to use `.specify/specs/`
   - Updated `find_feature_dir_by_prefix()` to search in `.specify/specs/`
   - Updated comments to reference new path

2. **`.specify/scripts/bash/create-new-feature.sh`**
   - Updated `SPECS_DIR` variable to point to `.specify/specs/`

3. **`.github/agents/speckit.specify.agent.md`**
   - Updated documentation to reference `.specify/specs/` for directory matching

4. **`.github/agents/speckit.tasks.agent.md`**
   - Fixed typo: `.specify.specify/` → `.specify/`

### Files Moved

All files from `specs/001-initial-ruby-setup/` were moved to `.specify/specs/001-initial-ruby-setup/`:
- `spec.md` - Feature specification
- `plan.md` - Implementation plan
- `tasks.md` - Task list
- `research.md` - Research notes
- `data-model.md` - Data model documentation
- `quickstart.md` - Quick start guide
- `checklists/` - Checklist documents
- `contracts/` - API contracts

### Old Directory Removed

The old `specs/` directory has been completely removed from the repository root.

## Benefits

1. **Consistency**: All Spec Kit related files are now under `.specify/` directory
2. **Organization**: Clear separation between project code and specification/planning documents
3. **Discoverability**: Easier to find all specification artifacts in one location
4. **Agent Compatibility**: All GitHub Copilot agents now correctly reference the unified location

## Agent Access

All Spec Kit agents have been verified to work with the new structure:

- **speckit.specify** - Creates new specifications
- **speckit.plan** - Creates implementation plans
- **speckit.tasks** - Generates task lists
- **speckit.analyze** - Analyzes specifications
- **speckit.clarify** - Clarifies requirements
- **speckit.implement** - Implements features
- **speckit.taskstoissues** - Converts tasks to GitHub issues

All agents use `.specify/scripts/bash/check-prerequisites.sh` which dynamically determines the `FEATURE_DIR` from `.specify/specs/`, ensuring they automatically work with the new location.

## Backwards Compatibility

### Breaking Changes

- Any scripts or tools that directly referenced `specs/` directory will need to be updated to use `.specify/specs/`
- Environment variables or configuration that pointed to the old location need updating

### Migration for Developers

If you have a local clone with the old structure:

1. Pull the latest changes from the repository
2. Delete your local `specs/` directory if it still exists
3. The new `.specify/specs/` directory will be pulled automatically
4. No changes needed to your workflow - all agents handle the new path automatically

## Verification

To verify the migration was successful:

```bash
# Check that the new structure exists
ls -la .specify/specs/

# Verify scripts work with new path
SPECIFY_FEATURE=001-initial-ruby-setup .specify/scripts/bash/check-prerequisites.sh --json

# Expected output should show FEATURE_DIR pointing to .specify/specs/001-initial-ruby-setup
```

## Future Considerations

- All new features should be created in `.specify/specs/` using the standard workflow
- The `.specify/` directory is the authoritative location for all Spec Kit artifacts
- No feature specifications should exist outside of `.specify/specs/`

## Related Documents

- [Constitution](memory/constitution.md) - Project principles and guidelines
- [Spec Template](templates/spec-template.md) - Template for new specifications
- [Plan Template](templates/plan-template.md) - Template for implementation plans
- [Tasks Template](templates/tasks-template.md) - Template for task lists

## Questions or Issues

If you encounter any issues with the new structure, please:

1. Check that you have the latest version from the repository
2. Verify the scripts are executable: `chmod +x .specify/scripts/bash/*.sh`
3. Create a GitHub issue with details about the problem
