# Sync GitHub

GitLab CI/CD component that pushes selected GitLab branches to a GitHub repository whenever a pipeline runs for a matching branch.

## 📌 Features

- Synchronizes selected GitLab branches to a GitHub repository.
- Supports configurable source branches through the `branches` input.
- Allows configuration of the target GitHub repository.
- Allows configuration of the GitLab CI/CD stage.
- Uses a hidden job to encapsulate the synchronization logic.
- Preserves Git history by requesting a complete clone with `GIT_DEPTH: "0"`.

## 🔧 Prerequisites

- A GitLab project using GitLab CI/CD.
- An existing GitHub repository as the synchronization target.
- A GitHub personal access token with permission to push to the target repository.
- The `GITHUB_TOKEN` CI/CD variable configured in the consuming GitLab project.
- The configured GitLab CI/CD stage must exist in the consuming project's pipeline configuration.

## 📥 Inputs

| Input         | Description                                                            | Default         | Required |
| ------------- | ---------------------------------------------------------------------- | --------------- | -------- |
| `branches`    | Pipe-separated list of GitLab branches to synchronize, without spaces. | `develop\|main` | No       |
| `github_repo` | Target GitHub repository in the format `owner/repo`.                   | —               | Yes      |
| `stage`       | GitLab CI stage used for the synchronization job.                      | `deploy`        | No       |

## 🚀 Usage

### Basic Example

Add the component to the consuming project's `.gitlab-ci.yml`.

Since the component is not yet published to the GitLab CI/CD Component Catalog, include it directly from the GitLab project:

```yaml
include:
  - project: "iphc/ci-templates"
    ref: "<branch-or-tag>"
    file: "/templates/sync-github/template.yml"
    inputs:
      github_repo: "<github-user>/<github-project>"
```

Replace `<group>`, `<project>`, and `<branch-or-tag>` with the actual GitLab group, project, and reference containing the component.

### Advanced Example

Configure the branches to synchronize and the stage used by the job:

```yaml
include:
  - project: "iphc/ci-templates"
    ref: "<branch-or-tag>"
    file: "/templates/sync-github/template.yml"
    inputs:
      github_repo: "<github-user>/<github-project>"
      branches: "main|develop|test"
      stage: deploy
```

Only branches matching the configured `branches` input are synchronized.

## 📂 Jobs

| Job            | Description                                                                                                                                                                             |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.sync-github` | Hidden job containing the GitHub synchronization configuration and commands. It is not executed directly.                                                                               |
| `sync-github`  | Concrete job extending `.sync-github`. It pushes the current GitLab branch to the corresponding branch in the configured GitHub repository when the branch matches the configured list. |

The synchronization job performs the following operations:

1. Installs Git in the `alpine:latest` image.
2. Removes an existing Git remote named `github`, if present.
3. Adds the configured GitHub repository as the `github` remote.
4. Pushes `HEAD` to the corresponding GitHub branch using `CI_COMMIT_BRANCH`.

The `GIT_DEPTH: "0"` setting requests a complete Git history.

## 🔐 Authentication

The consuming GitLab project must define the following CI/CD variable under **Settings → CI/CD → Variables**.

| Variable       | Description                                                                            |
| -------------- | -------------------------------------------------------------------------------------- |
| `GITHUB_TOKEN` | GitHub access token used to authenticate Git operations against the target repository. |

Configuration requirements:

- Store the token as a masked CI/CD variable.
- Mark the variable as protected if synchronization must only run on protected branches.
- Grant the token the minimum permissions required to push to the target GitHub repository.
- Ensure that the token is available to the synchronization job under the applicable GitLab variable protection rules.

Never hardcode the token in the component configuration or README examples.

## ⚠️ Notes

- The destination branch has the same name as the source GitLab branch.
- The target GitHub repository must already exist.
- The token must have permission to push to the target repository.
- The `branches` input uses `|` as a separator, without spaces.
- The component does not synchronize GitLab tags.
- The `stage` input must refer to a stage available in the consuming project's pipeline.
- `GIT_DEPTH: "0"` requests a complete Git history.
- The component should be validated against the actual `template.yml` before being used in production.

## 🔗 References

- [GitLab CI/CD components](https://docs.gitlab.com/ci/components/)
- [GitLab CI/CD component inputs](https://docs.gitlab.com/ci/inputs/)
- [GitLab CI/CD YAML syntax: `include`](https://docs.gitlab.com/ci/yaml/)
- [GitHub documentation: Managing personal access tokens](https://docs.github.com/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Git documentation: `git push`](https://git-scm.com/docs/git-push)
