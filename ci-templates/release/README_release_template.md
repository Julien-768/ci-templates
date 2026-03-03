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
  - project: "iphc/ci-templates"
    file: "/ci-templates/clang.gitlab-ci.yml"
    ref: "<commit-sha>"
  - project: "iphc/ci-templates"
    file: "/ci-templates/doxygen.gitlab-ci.yml"
    ref: "<commit-sha>"
  - project: "iphc/ci-templates"
    file: "/ci-templates/release.gitlab-ci.yml"
    ref: "<commit-sha>"
```

Define the stages in this order:

```yaml
stages:
  - release
```

No job definition is required locally.

Including the template is sufficient to enable the release workflow:

---

## 🔧 Variables you can override

- `CI_PUSH_TOKEN` _(required)_ – GitLab CI variable for authentication to push commits/tags.
- `CI_BOT_EMAIL` _(optional)_ – Email used in Git commits (`ci@example.com` by default).
- `CI_BOT_NAME` _(optional)_ – Git username for commits (`CI Bot` by default).
- `ZIP_PREFIX` _(optional)_ – Prefix of the zip file (`release` by default).

---

## 🧠 Important Notes

- **The `release` job only runs on `main`** and skips if the commit message matches `chore(release):`.
- **Do not** run this template on feature/dev branches or merge commits unless you know what you're doing.
- Use `standard-version` in your local dev workflow to preview what the next release would do.

---

## ⚠️ GitLab Release publication behavior (important)

On some GitLab instances or projects, the GitLab Release API may be restricted or partially disabled.

Typical symptoms include errors such as:

```text
422 Project must contain components
```

This can happen even when:

- the Git tag is correctly created,

- the ZIP archive is generated,

- the push succeeds.

### How the template handles this

- The `release` job is **authoritative**:
  - version bump

  - changelog

  - tag creation

  - ZIP archive generation

  - push to the repository

  These steps always run when conditions are met.

- The `gitlab-release` **job is best-effort**:
  - It attempts to publish a GitLab Release via release-cli

  - If the GitLab instance refuses Release creation, the job may fail

  - **This failure does NOT invalidate the release itself**

For this reason, the `gitlab-release` job is configured as **non-blocking** (`allow_failure: true`) in the template.

### Practical consequences

- Your project still gets a **valid release**:
  - Git tag `vX.Y.Z`

  - ZIP archive available as a pipeline artifact

- GitLab Release UI entry is created **only if the instance allows it**

- CI pipelines remain green and predictable across GitLab instances

### Recommendation__

Projects should rely on:

- **Git tags and release artifacts** as the canonical release output

- GitLab Release UI as an optional convenience layer

## 📦 Outputs

- **Artifact**: `release-vX.Y.Z.zip`
- **GitLab Release**: created via `release-cli` and accessible under the project’s Releases tab.
