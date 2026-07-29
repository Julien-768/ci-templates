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

---

## 🔧 Prerequisites

1. **MkDocs Project**: Your repository must contain a valid `mkdocs.yml` file.
2. **Mike Installed**: Ensure `mike` is listed in your `requirements.txt`:

   ```text
   mike
   mkdocs
   mkdocs-material  # or your preferred theme
   ```

3. **GitLab Token**: A **CI/CD token** with `write_repository` permissions is required for `CI_PUSH_TOKEN`.

---

## 📥 Inputs

| Input               | Description                                                                                                              | Default                 | Required |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------ | ----------------------- | -------- |
| `MK_PATH`           | Relative path to the MkDocs project directory (from `$CI_PROJECT_DIR`).                                                  | `.`                     | No       |
| `GITLAB_USER_NAME`  | Git user name for commits (used by Mike to push to `gl-pages`).                                                          | `GitLab CI`             | No       |
| `GITLAB_USER_EMAIL` | Git user email for commits.                                                                                              | `gitlab-ci@example.com` | No       |
| `CI_PUSH_TOKEN`     | GitLab [CI/CD token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) with `write_repository` scope. | _None_                  | **Yes**  |

---

## 🚀 Usage

### Basic Example

Include the template in your `.gitlab-ci.yml`:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/template.yml"
    ref: "main" # or a specific tag/commit
    inputs:
      CI_PUSH_TOKEN: $CI_PUSH_TOKEN # Define this variable in GitLab CI/CD settings
```

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
      CI_PUSH_TOKEN: $MY_CUSTOM_TOKEN

# Trigger deployment manually or via tags
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

## ⚠️ Notes

1. **GitLab Pages Branch**: The template uses `gl-pages` as the default branch for GitLab Pages. Ensure this branch is **not protected** (or add the CI token to the allowed list).
2. **Mike Configuration**: Your `mkdocs.yml` must be compatible with Mike. Example:

   ```yaml
   site_name: My Docs
   plugins:
     - mike:
         alias_type: symlink # Recommended for versioned docs
   ```

3. **Token Security**: Store `CI_PUSH_TOKEN` as a [GitLab CI/CD variable](https://docs.gitlab.com/ee/ci/variables/) (masked and protected).
4. **Debugging**: Uncomment the `echo` and `ls` commands in the template if you need to debug the deployment process.

---

## 🔗 References

- [Mike Documentation](https://github.com/jimporter/mike)
- [GitLab Pages](https://docs.gitlab.com/ee/user/projects/pages/)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)
