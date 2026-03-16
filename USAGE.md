# Example: Using release-and-publish Action

This is an example of how to use the `lalexdotcom/action-release-and-publish` action in your own repository.

## Basic Setup

Create `.github/workflows/release.yml` in your repository:

```yaml
name: Release and Publish

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
      - name: Checkout 🛎️
        uses: actions/checkout@v4

      - name: Release and Publish 🚀
        uses: lalexdotcom/action-release-and-publish@v1
        with:
          publish: true
        secrets:
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## What You Need

1. **Git tag** on main branch (e.g., `v1.0.0`, `v1.0.0-beta.1`)
2. **package.json** with:
   - `name` field
   - `version` field matching the tag (without `v` prefix)
   - `build` script
3. **NPM_TOKEN** secret in your repository settings (if publishing)

## Common Scenarios

### Release without publishing to NPM

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    publish: false
```

### Custom NPM registry

```yaml
- uses: lalexdotcom/action-release-and-publish@v1
  with:
    npm-registry: 'https://your-registry.com'
    publish: true
  secrets:
    NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### With notifications

```yaml
- name: Release and Publish 🚀
  uses: lalexdotcom/action-release-and-publish@v1
  with:
    publish: true
  secrets:
    NPM_TOKEN: ${{ secrets.NPM_TOKEN }}

- name: Notify Slack
  if: success()
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
```

## Versioning

Supported tag formats:
- `v1.0.0` — stable release
- `v1.0.0-alpha.1` — alpha prerelease
- `v1.0.0-beta.2` — beta prerelease
- `v1.0.0-rc.1` — release candidate

Prerelease versions are automatically tagged with their type in npm.
