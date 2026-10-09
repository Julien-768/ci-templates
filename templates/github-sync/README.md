# Sync GitHub

GitLab CI/CD component that pushes selected GitLab branches to a GitHub repository whenever a pipeline runs for a matching branch.

## Inputs

| Input         | Required | Default          | Description                                          |
| ------------- | -------- | ---------------- | ---------------------------------------------------- |
| `branches`    | No       | `develop` `main` | Pipe-separated list of branches to synchronize.      |
| `github_repo` | Yes      | —                | Target GitHub repository in the format `owner/repo`. |
| `stage`       | No       | `deploy`         | GitLab CI stage used for the synchronization job.    |

## Required CI/CD variable

Configure the following variable in the consuming GitLab project under **Settings → CI/CD → Variables**:

| Variable       | Description                                                              |
| -------------- | ------------------------------------------------------------------------ |
| `GITHUB_TOKEN` | GitHub Personal Access Token with write access to the target repository. |

Store the token as a masked variable. Protect it if synchronization should only be allowed from protected branches.

## Usage

Add the component to the consuming project's `.gitlab-ci.yml`:

```yaml
include:
  - component: $CI_SERVER_FQDN/<group>/<project>/sync-github@<version>
    inputs:
      github_repo: "Julien-768/rfid-m0-wiki"
      branches: "main|develop|test"
      stage: deploy
```

Replace `<group>`, `<project>`, and `<version>` with the component's actual GitLab location and version.

## How it works

The component defines a hidden job, `.sync-github`, containing the synchronization commands. The concrete `sync-github` job extends this template.

When the current branch matches the configured `branches` input, the job:

1. Installs Git in the `alpine:latest` image.
2. Removes an existing `github` remote if present.
3. Adds the target GitHub repository as the `github` remote.
4. Pushes `HEAD` to the corresponding GitHub branch using `CI_COMMIT_BRANCH`.

`GIT_DEPTH: "0"` requests a complete Git history.

## Notes

- The destination branch has the same name as the source GitLab branch.
- The target GitHub repository must exist, and the token must have permission to push to it.
- The component does not synchronize GitLab tags.
- The `branches` input is a '|' list without spaces.
