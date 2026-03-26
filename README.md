# Release and Publish Action

Automated release and publish action for npm packages with git tagging, version validation, and GitHub releases.

## Features

✅ **Auto-detection** of package manager (npm, pnpm, yarn)
✅ **Tag validation** - enforces semantic versioning format (v{major}.{minor}.{patch}[-{prerelease}])
✅ **NPM publishing** - with automatic dist-tags (latest, next, beta, rc)
✅ **GitHub Releases** - automatically created with release notes
✅ **Prerelease detection** - handles alpha, beta, rc, and stable versions
✅ **Multi-package-manager support** - works with npm, pnpm, and yarn

## Usage

Create `.github/workflows/release.yml` in your repo:

```yaml
name: Release

on:
  push:
    tags:
      - "v*.*.*"
      - "v*.*.*-*"

jobs:
  release:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: lalexdotcom/action-release-and-publish@v1
        with:
          publish: true
          npm-token: ${{ secrets.NPM_TOKEN }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

### `npm-registry`

**Optional** | Default: `https://registry.npmjs.org`

The npm registry URL to publish to.

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    npm-registry: https://registry.npmjs.org
```

### `publish`

**Optional** | Default: `true`

Whether to publish to npm. Set to `false` to just create a GitHub release.

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    publish: false
```

### `node-version`

**Optional** | Default: `lts/*`

The Node.js version to use for building and publishing. Accepts any value supported by [actions/setup-node](https://github.com/actions/setup-node) (e.g., `18`, `20.x`, `lts/hydrogen`).

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    node-version: '20'
```

### `npm-token`

**Required** when `publish: true`

Your npm authentication token for publishing packages.

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    npm-token: ${{ secrets.NPM_TOKEN }}
```

### `github-token`

**Required**

GitHub token used to create releases and query the API.

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Requirements

- `package.json` with:
  - `name` field
  - `version` field matching the git tag (without 'v' prefix)
  - `build` script
- Semantic versioned git tags (e.g., `v1.0.0`, `v1.0.0-beta.1`)
- `NPM_TOKEN` secret configured in your repository (for publishing)
- `GITHUB_TOKEN` available in your workflow (automatically provided by GitHub)

## Version Numbering

Tags must follow semantic versioning:

- `v1.0.0` - stable release
- `v1.0.0-alpha.1` - alpha prerelease
- `v1.0.0-beta.2` - beta prerelease
- `v1.0.0-rc.1` - release candidate

Prerelease versions are automatically tagged with their prerelease type in npm (alpha, beta, rc).

## Example Workflow

### Complete example with setup

```yaml
name: Release

on:
  push:
    tags:
      - "v*.*.*"
      - "v*.*.*-*"

jobs:
  release:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: lalexdotcom/action-release-and-publish@v1
        with:
          npm-registry: 'https://registry.npmjs.org'
          publish: true
          npm-token: ${{ secrets.NPM_TOKEN }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Release without publishing to npm

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    publish: false
```

## License

MIT
