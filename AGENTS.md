# Commit Conventions for AI Agents

This document ensures that AI agents and code generation tools follow proper commit conventions for automatic versioning.

The `release.yml` workflow analyzes commits on every push to `main` and automatically bumps the version, creates tags, and publishes a GitHub Release — **no manual action needed**.

## Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
type(scope): description

[optional body]

[optional footer]
```

## Types

- **feat**: A new feature (triggers: MINOR version bump)
- **fix**: A bug fix (triggers: PATCH version bump)
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Code change that improves performance
- **test**: Adding or updating tests
- **chore**: Changes to build process, dependencies, or tooling

## Examples

### New Feature
```
feat(action): add support for custom registry authentication
```

### Bug Fix
```
fix(setup): resolve node version detection issue
```

### Breaking Change
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) defines two
ways to mark a breaking change, and the release workflow detects both. Prefer the
`!` suffix — it is visible in a one-line log, where a footer is not:

```
feat(action)!: redesign package manager detection
```

The footer form stays available when the break needs explaining:

```
feat(action): redesign package manager detection

BREAKING CHANGE: The `detect-pm` output name has changed to `pm`
```

Either one triggers: **MAJOR** version bump. They can be combined, and
`BREAKING-CHANGE:` is accepted as a spec synonym of `BREAKING CHANGE:`.

> ⚠️ Only the **subject line** decides the type. A body line reading
> `fixes the parser` or `features added:` does not trigger a bump — the type
> must be a real prefix, as in `fix: …` or `feat(scope)!: …`.

## Automatic Version Bumps

- **MAJOR**: Breaking changes (`BREAKING CHANGE:` footer or `!` suffix)
- **MINOR**: New features (`feat:`)
- **PATCH**: Bug fixes (`fix:`)

## Guidelines for Agents

When generating or modifying code in this repository:

1. **Always use conventional commits** for all code changes
2. **Use meaningful scopes** that reflect the changed component (e.g., `action`, `setup`, `validation`)
3. **Keep descriptions clear and concise**
4. **For multi-part changes**, consider whether they should be:
   - One commit with scope covering all
   - Multiple commits, each with appropriate type
5. **Avoid generic messages** like "update code" or "fix stuff"
6. **When unsure of type**, prefer `fix` or `chore` over vague categories
7. **`chore`, `docs`, `style`, `refactor`, `perf`, `test`** commits do **not trigger a release** — only `feat`, `fix`, and breaking changes (`!` or `BREAKING CHANGE:`) do

## Examples in This Action

### Good commits:
- `fix(validation): improve tag format regex`
- `feat(detect): add pnpm support`
- `docs: add registry configuration example`

### Avoid:
- `update action` ❌
- `fix bug` ❌
- `make changes` ❌
