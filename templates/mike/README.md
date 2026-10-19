# Mike Documentation Deployment Template

**Deploys versioned MkDocs documentation using [Mike](https://github.com/jimporter/mike) to GitLab Pages.**

This GitLab CI template automates the deployment of versioned documentation with Mike. It supports multiple documentation versions (e.g., `latest`, `dev`, version tags, or merge request previews) and publishes the generated site through GitLab Pages.

---

## 📌 Features

- **Versioned Documentation**: Maintains multiple documentation versions in a dedicated Git branch.
- **Selectable Execution Mode**: Choose whether the job runs on a branch, in merge request pipelines, or both, through `job_execution_mode`.
- **Flexible Publication Trigger**: In merge request pipelines, the keyword can be placed in the commit message, the merge request title, or the merge request description.
- **Automatic Default Version**: Updates the `latest` alias and sets it as the default version (never from a merge request pipeline).
- **Merge Request Versions**: Publishes a dedicated `mr-<iid>` version for each merge request when the merge request mode is enabled.
- **Branch Exclusion**: Never runs on a configurable excluded branch, whether in a branch pipeline or a merge request pipeline.
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

4. **Merge request pipelines** (only for the `merge_request` and `both` modes): If the project defines a `workflow:rules` section, it must allow pipelines triggered by `merge_request_event`.

5. **GitLab 16.7 or later** (only to use the keyword in the merge request description): The `CI_MERGE_REQUEST_DESCRIPTION` variable is not available on older versions. On older versions, use the commit message or the merge request title.

---

## 📥 Inputs

| Input                 | Description                                                                                                                                                     | Default                 |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `mk_path`             | Path to the MkDocs project directory, relative to `$CI_PROJECT_DIR`.                                                                                            | `.`                     |
| `mkdocs_config_file`  | MkDocs configuration filename, relative to `mk_path`.                                                                                                           | `mkdocs.yml`            |
| `pages_stage`         | CI/CD stage used by the deployment job.                                                                                                                         | `deploy`                |
| `job_execution_mode`  | Where the job can run: `branch` (on `publication_branch`), `merge_request` (in merge request pipelines), or `both`.                                             | `branch`                |
| `publication_branch`  | Branch on which a matching commit message triggers publication (modes `branch` and `both`).                                                                     | `develop`               |
| `publication_keyword` | Keyword (regular expression) that triggers publication. Looked for in the commit message and, in merge request pipelines, also in the MR title and description. | `publication`           |
| `exclusion_branch`    | Branch on which the job never runs (branch pipelines and merge requests whose source branch is this branch).                                                    | `exclusion-branch`      |
| `mike_branch`         | Git branch used to store versioned documentation.                                                                                                               | `pages/mike`            |
| `gitlab_user_name`    | Git author name for generated commits.                                                                                                                          | `GitLab CI`             |
| `gitlab_user_email`   | Git author email for generated commits.                                                                                                                         | `gitlab-ci@example.com` |

All inputs are optional and have defaults.

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
      job_execution_mode: "both"
      publication_branch: "develop"
      publication_keyword: "publication"
      exclusion_branch: "exclusion-branch"
      mike_branch: "pages/mike"
```

Replace `iphc/ci-templates`, the file path, and the reference with the actual project path and version used in your environment.

Ensure that the `pages` stage exists in the main pipeline's `stages` list, or use an existing stage.

### Execution modes

The `job_execution_mode` input controls when the job `mike_pages` can run:

| Mode            | The job runs...                                                                                                                                |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `branch`        | In branch pipelines on `publication_branch`, when the commit message contains `publication_keyword`.                                           |
| `merge_request` | In merge request pipelines, when the commit message, the merge request title, or the merge request description contains `publication_keyword`. |
| `both`          | In both cases above.                                                                                                                           |

In every mode, the job never runs on `exclusion_branch` (as a branch, or as the source branch of a merge request).

To restrict merge request publication to merge requests targeting a specific branch, add a condition on `$CI_MERGE_REQUEST_TARGET_BRANCH_NAME` to the merge request rule of the template.

### Publication trigger

In branch pipelines, a commit message containing the keyword (e.g. `publication`) triggers the job when the execution mode and the branch conditions are met.

In merge request pipelines, the keyword can be placed in any of the following:

- the message of the last commit of the source branch;
- the merge request title;
- the merge request description.

Notes on the merge request trigger:

- The match is case-sensitive: `Publication` does not match `publication`.
- The keyword is used as a regular expression. Escape special characters if you choose a keyword such as `[publish-docs]` (use `\[publish-docs\]`).
- The variables are read when the pipeline is created. After adding the keyword to the title or description, click **Run pipeline** in the merge request or push a new commit.
- The description is truncated by GitLab in the pipeline variable (2700 characters), so place the keyword near the beginning.
- The keyword may appear in free text without the intent to publish. Use a more specific keyword if this is a risk.

The documentation version is selected as follows:

| Context                  | Version published | `latest` alias and default version |
| ------------------------ | ----------------- | ---------------------------------- |
| Tagged commit            | The Git tag       | Updated                            |
| Untagged commit (branch) | `dev`             | Updated                            |
| Merge request pipeline   | `mr-<iid>`        | Not modified                       |

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

extra:
  version:
    provider: mike
```

The `extra.version.provider: mike` setting enables the version selector with the Material theme.

Adapt this example to the MkDocs and Mike versions used by your project.

---

## ⚠️ Notes

1. **Version history**: Mike stores multiple documentation versions in the configured `mike_branch`.
2. **Default version**: The template sets `latest` as the default version, except for merge request pipelines.
3. **GitLab Pages**: The published site is generated from the `public/` artifact produced by the CI job. A deployment from a merge request pipeline replaces the main site; for isolated previews, consider GitLab Pages parallel deployments (`pages.path_prefix`).
4. **Merge request versions**: `mr-<iid>` versions are published on the same site as the other versions and are therefore as visible as them. They are never deleted automatically, so the version list grows over time. Remove obsolete ones with:

   ```bash
   mike delete mr-<iid> --push --branch pages/mike
   ```

   This can be automated with a dedicated job, for example when a merge request is closed or merged.

5. **Branch protection**: If the publication branch is protected, its rules must allow the CI job to push.
6. **Publication rules**: In branch pipelines, the job checks the commit message for the configured keyword. In merge request pipelines, it checks the commit message, the merge request title, and the merge request description. Remove these conditions from the rules of the template if merge request pipelines should publish without the keyword.
7. **Debugging**: Inspect the job logs if dependency installation, Git authentication, or publication fails. If the job does not appear in a merge request pipeline, check the keyword (case, location) and that the pipeline was created after the keyword was added.

---

## 🔗 References

- [Mike documentation](https://github.com/jimporter/mike)
- [GitLab CI/CD components](https://docs.gitlab.com/ci/components/)
- [GitLab Pages](https://docs.gitlab.com/user/project/pages/)
- [GitLab CI/CD job token](https://docs.gitlab.com/ci/jobs/ci_job_token/)
- [GitLab merge request pipelines](https://docs.gitlab.com/ci/pipelines/merge_request_pipelines/)
