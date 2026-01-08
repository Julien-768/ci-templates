
# GitLab CI Release Template – Documentation

This documentation explains how to use the `release.gitlab-ci.yml` template provided by `iphc/ci-templates`
to automate version bumping, tagging, zipping and publishing a GitLab release.

## ✅ What it does

The template provides **two jobs**:

1. **`release`**
   - Runs only on the `main` branch when a commit is pushed.
   - Skips commits of type `chore(release):` to avoid infinite loops.
   - Bumps the version using `standard-version`.
   - Generates or updates `CHANGELOG.md`.
   - Commits the version bump and changelog.
   - Tags the commit with `vX.Y.Z`.
   - Archives the source tree at that tag into a ZIP file (`release-vX.Y.Z.zip`).
   - Pushes the commit and the tag.
   - Exports environment variables `VERSION`, `TAG`, and `ZIP_NAME` to a `.env` file.

2. **`gitlab_release`**
   - Only runs in the same pipeline as the `release` job (not on tags directly).
   - Publishes a GitLab release using `release-cli`.
   - Reuses the zip archive as a release asset.

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - project: 'iphc/ci-templates'
    file: '/ci-templates/clang.gitlab-ci.yml'
    ref: '<commit-sha>'
  - project: 'iphc/ci-templates'
    file: '/ci-templates/doxygen.gitlab-ci.yml'
    ref: '<commit-sha>'
  - project: 'iphc/ci-templates'
    file: '/ci-templates/release.gitlab-ci.yml'
    ref: '<commit-sha>'
```

Define the stages in this order:

```yaml
stages:
  - format
  - pages
  - release
```

Then extend the jobs:

```yaml
release:
  extends: .release-template

gitlab_release:
  extends: .gitlab-release-template
```

---

## 🔧 Variables you can override

- `CI_PUSH_TOKEN` *(required)* – GitLab CI variable for authentication to push commits/tags.
- `CI_BOT_EMAIL` *(optional)* – Email used in Git commits (`ci@example.com` by default).
- `CI_BOT_NAME` *(optional)* – Git username for commits (`CI Bot` by default).
- `ZIP_PREFIX` *(optional)* – Prefix of the zip file (`release` by default).
- `FILES_TO_PACKAGE` – Used by `git archive` to select what files to include (default: `src include lib platformio.ini README.md CHANGELOG.md`).

---

## 🧠 Important Notes

- **The `release` job only runs on `main`** and skips if the commit message matches `chore(release):`.
- **Do not** run this template on feature/dev branches or merge commits unless you know what you're doing.
- Use `standard-version` in your local dev workflow to preview what the next release would do.

---

## 📦 Outputs

- **Artifact**: `release-vX.Y.Z.zip`
- **GitLab Release**: created via `release-cli` and accessible under the project’s Releases tab.

