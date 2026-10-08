# Mike Documentation Deployment Template

**Deploys MkDocs documentation using [Mike](https://github.com/jimporter/mike) to GitLab Pages.**

This template automates the deployment of versioned documentation with Mike, allowing you to serve multiple versions of your MkDocs site (e.g., `latest`, `dev`, or version tags) via GitLab Pages.

---

## 📌 Features

- **Versioned Documentation**: Deploy multiple versions of your docs (e.g., `latest`, `v1.0`, `dev`).
- **Automatic Default Version**: Sets the `latest` version as the default for GitLab Pages.
- **Caching**: Uses `PIP_CACHE_DIR` to speed up dependency installation.
- **Flexible Paths**: Customize the MkDocs project directory via `MK_PATH`.
- **GitLab Pages Integration**: Deploys to the `gl-pages` branch by default.
- **CI Job Token Authentication**: Uses the GitLab-provided `CI_JOB_TOKEN` to push the generated documentation.

---

## 🔧 Prerequisites

1. **MkDocs Project**: Your repository must contain a valid `mkdocs.yml` file.

2. **Mike Installed**: Ensure `mike` is listed in your `requirements.txt`:

   ```text
   mike
   mkdocs
   mkdocs-material  # or your preferred theme
   ```

3. **GitLab CI Job Token Push Access**: The project must allow CI jobs to push to the repository.

   In GitLab, enable:

   **Settings → CI/CD → Job token permissions → Allow Git push requests to the repository**

   The template uses the automatically provided `CI_JOB_TOKEN` for Git authentication. No personal access token or custom CI/CD token is required.

---

## 📥 Inputs

| Input               | Description                                                             | Default                 | Required |
| ------------------- | ----------------------------------------------------------------------- | ----------------------- | -------- |
| `MK_PATH`           | Relative path to the MkDocs project directory (from `$CI_PROJECT_DIR`). | `.`                     | No       |
| `GITLAB_USER_NAME`  | Git user name for commits (used by Mike to push to `gl-pages`).         | `GitLab CI`             | No       |
| `GITLAB_USER_EMAIL` | Git user email for commits.                                             | `gitlab-ci@example.com` | No       |

No token input is required. The template uses the GitLab-provided `CI_JOB_TOKEN`.

---

## 🚀 Usage

### Basic Example

Include the template in your `.gitlab-ci.yml`:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/mike.gitlab-ci.yml"
    ref: "main" # or a specific tag/commit
```

No token or additional authentication variable is required.

### Advanced Example

Customize inputs and trigger deployment only for tagged commits:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/template.yml"
    ref: "<commit-sha>"
    inputs:
      MK_PATH: "docs"
      GITLAB_USER_NAME: "MyBot"
      GITLAB_USER_EMAIL: "mybot@example.com"

mike_pages:
  extends: .mike-pages-template
  rules:
    - if: "$CI_COMMIT_TAG" # Deploy only for tags
    - if: "$CI_COMMIT_MESSAGE =~ /deploy-docs/" # Or via commit message
```

---

## 📂 Jobs

| Job          | Description                                                                                                   |
| ------------ | ------------------------------------------------------------------------------------------------------------- |
| `mike_pages` | Deploys the documentation to GitLab Pages using Mike. Triggered by commits with `publication` in the message. |

---

## 🔐 Authentication

The template uses the GitLab-provided `CI_JOB_TOKEN` for authentication when pushing the versioned documentation.

The remote repository is configured as:

```yaml
HTTPS_REMOTE: "https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git"
```

No personal access token, deploy token, or custom `CI/CD` variable is required.

### Required GitLab Configuration

Enable the following project setting:

- **Settings → CI/CD → Job token permissions → Allow Git push requests to the repository**

This allows the `CI_JOB_TOKEN` generated for the pipeline to push to the repository.

---

## ⚠️ Notes

1. **GitLab Pages Branch**: The template uses `gl-pages` as the default branch for GitLab Pages.

2. **CI Job Token**: Authentication is performed using the automatically generated `CI_JOB_TOKEN`. The token is temporary and does not need to be manually created or stored as a CI/CD variable.

3. **Protected Branches**: If `gl-pages` is protected, its branch protection rules must allow the CI job to perform the required push.

4. **Mike Configuration**: Your `mkdocs.yml` must be compatible with Mike. Example:

   ```yaml
   site_name: My Docs
   plugins:
     - mike:
         alias_type: symlink # Recommended for versioned docs
   ```

5. **Debugging**: Uncomment the `echo` and `ls` commands in the template if you need to debug the deployment process.

---

## 🔗 References

- [Mike Documentation](https://github.com/jimporter/mike)
- [GitLab Pages](https://docs.gitlab.com/ee/user/projects/pages/)
- [GitLab CI/CD Job Token](https://docs.gitlab.com/ee/ci/jobs/ci_job_token/)
