# Mike Documentation Deployment Template

**Deploys versioned MkDocs documentation using [Mike](https://github.com/jimporter/mike) to GitLab Pages.**

This GitLab CI template automates the deployment of versioned documentation with Mike. It supports multiple documentation versions (e.g., `latest`, `dev`, or version tags) and publishes the generated site through GitLab Pages.

---

## 📌 Features

- **Versioned Documentation**: Maintains multiple documentation versions in a dedicated Git branch.
- **Automatic Default Version**: Updates the `latest` alias and sets it as the default version.
- **Flexible Paths**: Supports MkDocs projects located in a configurable directory via `mk_path`.
- **Configurable MkDocs Setup**: Supports a custom MkDocs configuration file.
- **GitLab Pages Integration**: Publishes the generated documentation through GitLab Pages.
- **Dedicated Publication Branch**: Uses `pages/mike` by default to store versioned documentation.
- **Pip Caching**: Uses `PIP_CACHE_DIR` to cache Python packages.
- **CI Job Token Authentication**: Uses `CI_JOB_TOKEN` for Git authentication and pushing documentation, provided the project permissions allow it.

---

## 🔧 Prerequisites

1. **MkDocs project**: The repository must contain a valid `mkdocs.yml` configuration file, or another file specified through `mkdocs_config_file`.

2. **Python dependencies**: The directory specified by `mk_path` must contain a `requirements.txt` file listing the required packages, including Mike and MkDocs.

   Example:

   ```text
   mike
   mkdocs
   mkdocs-material
   ```

3. **GitLab CI/CD permissions**: The pipeline must be allowed to push to the repository using `CI_JOB_TOKEN`.

   Check the project's CI/CD job token permissions and enable **Allow Git push requests to the repository** if available for your GitLab version and project configuration.

   The target branch's protection rules must also permit the required push.

---

## 📥 Inputs

| Input                 | Description                                                          | Default                 |
| --------------------- | -------------------------------------------------------------------- | ----------------------- |
| `mk_path`             | Path to the MkDocs project directory, relative to `$CI_PROJECT_DIR`. | `.`                     |
| `mkdocs_config_file`  | MkDocs configuration filename, relative to `mk_path`.                | `mkdocs.yml`            |
| `pages_stage`         | CI/CD stage used by the deployment job.                              | `deploy`                |
| `publication_branch`  | Intended branch for publication triggers.                            | `develop`               |
| `publication_keyword` | Keyword required in the commit message to trigger publication.       | `publication`           |
| `mike_branch`         | Git branch used to store versioned documentation.                    | `pages/mike`            |
| `gitlab_user_name`    | Git author name for generated commits.                               | `GitLab CI`             |
| `gitlab_user_email`   | Git author email for generated commits.                              | `gitlab-ci@example.com` |

All inputs are optional and have defaults.

**Note:** In the current implementation, `publication_branch` is declared but is not used in the job's `rules`. Publication is triggered by the commit-message keyword, regardless of the branch. Add a branch condition to the CI rules if publication must be restricted to `develop`.

---

## 🚀 Usage

### Include the template

Include the template from the shared CI templates project in your `.gitlab-ci.yml`:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/template.yml"
    ref: "main"
    inputs:
      mk_path: "docs"
      mkdocs_config_file: "mkdocs.yml"
      pages_stage: "pages"
      publication_branch: "develop"
      publication_keyword: "publication"
      mike_branch: "pages/mike"
```

Replace `iphc/ci-templates`, the file path, and the reference with the actual project path and version used in your environment.

Ensure that the `pages` stage exists in the main pipeline's `stages` list, or use an existing stage.

### Publication trigger

The job `mike_pages` runs when the commit message matches the configured `publication_keyword`.

For example, a commit message containing `publication` triggers the job.

The current implementation selects the documentation version as follows:

- **Tagged commit**: Uses the Git tag as the version.
- **Untagged commit**: Uses `dev`.

The job updates the `latest` alias and sets `latest` as the default version.

---

## 📂 Jobs

| Job          | Description                                                                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `mike_pages` | Builds and publishes versioned MkDocs documentation using Mike, then exports the published site as the `public/` artifact for GitLab Pages. |

The job extends the hidden `.mike-template` job defined by the component.

---

## 🔐 Authentication

The template uses the GitLab-provided `CI_JOB_TOKEN` to authenticate Git operations that push documentation.

The remote URL is constructed as follows:

```text
https://gitlab-ci-token:${CI_JOB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git
```

No personal access token or custom token variable is required when the project's GitLab configuration permits push operations using `CI_JOB_TOKEN`.

### Required GitLab configuration

Verify that:

- Push requests using `CI_JOB_TOKEN` are enabled for the project.
- The job token has the required permissions.
- Branch protection rules allow the CI job to push to the `mike_branch`.

---

## 🌿 Publication branch

The `mike_branch` input defaults to `pages/mike`.

This is an ordinary Git branch dedicated to storing the versioned documentation generated by Mike. The `pages/` prefix does not provide any special behavior in GitLab.

The job checks whether the remote branch exists and creates a local branch from the current commit if the remote branch is not found. Mike then updates the versioned documentation and pushes the result.

Avoid modifying this branch manually unless you intend to change the published documentation history.

---

## ⚙️ MkDocs and Mike configuration

Make sure that your `mkdocs.yml` is compatible with Mike and that the required plugins and theme are installed through `requirements.txt`.

Example:

```yaml
site_name: My Docs

plugins:
  - mike:
      alias_type: symlink
```

Adapt this example to the MkDocs and Mike versions used by your project.

---

## ⚠️ Notes

1. **Version history**: Mike stores multiple documentation versions in the configured `mike_branch`.
2. **Default version**: The template sets `latest` as the default version.
3. **GitLab Pages**: The published site is generated from the `public/` artifact produced by the CI job.
4. **Branch protection**: If the publication branch is protected, its rules must allow the CI job to push.
5. **Publication rules**: The current job checks the commit message for the configured keyword. The `publication_branch` input does not yet restrict the triggering branch.
6. **Debugging**: Inspect the job logs if dependency installation, Git authentication, or publication fails.

---

## 🔗 References

- [Mike documentation](https://github.com/jimporter/mike)
- [GitLab CI/CD components](https://docs.gitlab.com/ci/components/)
- [GitLab Pages](https://docs.gitlab.com/user/project/pages/)
- [GitLab CI/CD job token](https://docs.gitlab.com/ci/jobs/ci_job_token/)
