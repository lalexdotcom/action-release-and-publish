# Release and Publish Action

Automated release and publish action for npm packages with git tagging, version validation, and GitHub releases.

## Features

- ✅ **Auto-detection** of package manager (npm, pnpm, yarn)
- ✅ **Tag validation** - enforces semantic versioning format (v{major}.{minor}.{patch}[-{prerelease}])
- ✅ **Version/tag consistency** - fails early if `package.json` version doesn't match the pushed tag
- ✅ **NPM publishing** - with automatic dist-tags (latest, latest-{major}, next, alpha, beta, rc), pruned when they fall behind
- ✅ **GitHub Releases** - automatically created with release notes
- ✅ **Prerelease detection** - handles alpha, beta, rc, and stable versions
- ✅ **Multi-package-manager support** - works with npm, pnpm, and yarn

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

      - uses: lalexdotcom/action-release-and-publish@v3
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
- uses: lalexdotcom/action-release-and-publish@v3
  with:
    npm-registry: https://registry.npmjs.org
```

### `publish`

**Optional** | Default: `true`

Whether to publish to npm. Set to `false` to just create a GitHub release.

```yaml
- uses: lalexdotcom/action-release-and-publish@v3
  with:
    publish: false
```

### `node-version`

**Optional** | Default: `lts/*`

The Node.js version to use for building and publishing. Accepts any value supported by [actions/setup-node](https://github.com/actions/setup-node) (e.g., `18`, `20.x`, `lts/hydrogen`).

```yaml
- uses: lalexdotcom/action-release-and-publish@v3
  with:
    node-version: '20'
```

### `npm-token`

**Required** when `publish: true`

Your npm authentication token for publishing packages.

```yaml
- uses: lalexdotcom/action-release-and-publish@v3
  with:
    npm-token: ${{ secrets.NPM_TOKEN }}
```

### `github-token`

**Required**

GitHub token used to create releases and query the API.

```yaml
- uses: lalexdotcom/action-release-and-publish@v3
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

### `release-notes-file`

**Optional** | Default: none

Path to a file whose content becomes the GitHub Release body. GitHub's generated
notes are appended after it, so the `Full Changelog` link is preserved. When
omitted, generated notes are used alone. The file is produced by your own
workflow — this action only reads the path.

The job fails if the path is set but unreadable, rather than falling back to
generated notes: an empty release body is only noticed after publication.

```yaml
- name: Build the release body 📝
  id: notes
  shell: bash
  run: |
    # e.g. the section of CHANGELOG.md matching this tag
    echo "file=$RUNNER_TEMP/release-notes.md" >> "$GITHUB_OUTPUT"

- uses: lalexdotcom/action-release-and-publish@v3
  with:
    release-notes-file: ${{ steps.notes.outputs.file }}
```

## Requirements

- `package.json` with:
  - `name` field
  - `version` field matching the git tag (without 'v' prefix) — the action verifies this and fails before building if it doesn't
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

## Dist-tags

| Published version | npm dist-tag |
|---|---|
| stable, higher than the current `latest` | `latest` |
| stable, on an older line (e.g. `1.9.1` after `2.0.0`) | `latest-{major}` (`latest-1`); `latest` does not move back |
| prerelease | its type (`alpha`, `beta`, `rc`...) |
| `rc` | also `next` |
| very first publication, prerelease | also `latest` |

When a stable becomes `latest`, every other tag still pointing at an older
prerelease is removed: after `2.0.0`, a `next` on `2.0.0-rc.2` or a `beta` on
`2.0.0-beta.3` would install something older than `latest`. A `beta` on
`3.0.0-beta.1` stays. Tags pointing at a release (`latest-1`, `lts`, `legacy`...)
are never touched.

On GitHub, a patch on an older line is created with `--latest=false`, so the
"Latest" badge stays on the highest release.

> The `stable` dist-tag, which only duplicated `latest`, is no longer set, and is
> removed from the registry by the next stable release.

## License

MIT
