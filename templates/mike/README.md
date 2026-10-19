# Mike Documentation Deployment Template

**Deploys versioned MkDocs documentation using [Mike](https://github.com/jimporter/mike) to GitLab Pages.**

This GitLab CI template automates the deployment of versioned documentation with Mike. It supports multiple documentation versions (e.g., `latest`, `dev`, version tags, or merge request previews) and publishes the generated site through GitLab Pages. It is intended to be consumed through a file-based include (`include: project` + `file`).

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
- **Dedicated Publication Branch**: Uses `pages/mike` by default to store versioned documentation (generated site only, no project sources).
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

| Input                 | Description                                                                                                                                                     | Default                 | Required |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- | -------- |
| `mk_path`             | Path to the MkDocs project directory, relative to `$CI_PROJECT_DIR`.                                                                                            | `.`                     | No       |
| `mkdocs_config_file`  | MkDocs configuration filename, relative to `mk_path`.                                                                                                           | `mkdocs.yml`            | No       |
| `pages_stage`         | CI/CD stage used by the deployment job.                                                                                                                         | `deploy`                | No       |
| `job_execution_mode`  | Where the job can run: `branch` (on `publication_branch`), `merge_request` (in merge request pipelines), or `both`.                                             | `branch`                | No       |
| `publication_branch`  | Branch on which a matching commit message triggers publication (modes `branch` and `both`).                                                                     | `develop`               | No       |
| `publication_keyword` | Keyword (regular expression) that triggers publication. Looked for in the commit message and, in merge request pipelines, also in the MR title and description. | `publication`           | No       |
| `exclusion_branch`    | Branch on which the job never runs (branch pipelines and merge requests whose source branch is this branch).                                                    | `exclusion-branch`      | No       |
| `mike_branch`         | Git branch used to store versioned documentation.                                                                                                               | `pages/mike`            | No       |
| `gitlab_user_name`    | Git author name for generated commits.                                                                                                                          | `GitLab CI`             | No       |
| `gitlab_user_email`   | Git author email for generated commits.                                                                                                                         | `gitlab-ci@example.com` | No       |

All inputs are optional and have defaults.

---

## 🚀 Usage

### Basic Example

Include the template from the shared CI templates project in your `.gitlab-ci.yml`, with a file-based include:

```yaml
stages:
  - deploy

include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/template.yml"
    ref: "main"
```

With the default inputs, the job runs in branch pipelines on `develop` when the commit message contains `publication`. The MkDocs project (`mkdocs.yml` and `requirements.txt`) is expected at the repository root.

Replace `iphc/ci-templates` and the reference with the actual project path and version used in your environment.

### Advanced Example

```yaml
stages:
  - build
  - pages

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
      gitlab_user_name: "GitLab CI"
      gitlab_user_email: "gitlab-ci@example.com"
```

Ensure that the stage given by `pages_stage` exists in the main pipeline's `stages` list, or use an existing stage.

If `mkdocs.yml` is at the repository root while `requirements.txt` is in `docs/`, use:

```yaml
inputs:
  mk_path: "docs"
  mkdocs_config_file: "../mkdocs.yml"
```

### Execution modes

The `job_execution_mode` input controls when the job `mike_pages` can run:

| Mode            | The job runs...                                                                                                                                |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `branch`        | In branch pipelines on `publication_branch`, when the commit message contains `publication_keyword`.                                           |
| `merge_request` | In merge request pipelines, when the commit message, the merge request title, or the merge request description contains `publication_keyword`. |
| `both`          | In both cases above.                                                                                                                           |

In every mode, the job never runs on `exclusion_branch` (as a branch, or as the source branch of a merge request).

To restrict merge request publication to merge requests targeting a specific branch, add a condition on `$CI_MERGE_REQUEST_TARGET_BRANCH_NAME` to the merge request rule of the template.

> **Important:** the `latest` alias and the redirect from the site root to `latest/` are only created by a non-merge-request deployment. With `job_execution_mode: "merge_request"` alone, `latest` is never created (see [First deployment](#first-deployment)).

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

### Custom publication keyword (regular expression)

`publication_keyword` is injected as a regular expression into the rules of the job (`$CI_COMMIT_MESSAGE =~ /<publication_keyword>/`). It can therefore describe several triggers at once, not only a single word.

Example: publish when a merge request is merged into `develop` **or** when the commit message contains `publication`:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mike/template.yml"
    ref: "main"
    inputs:
      job_execution_mode: "branch"
      publication_branch: "develop"
      publication_keyword: "(^Merge branch .+ into .?develop.?)|(publication)"
```

How the expression is read:

| Part             | Meaning                                                                                                             |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- |
| `^Merge branch ` | The message starts with `Merge branch `, the beginning of the message generated by GitLab for a merge commit.       |
| `.+`             | The name of the source branch (any characters).                                                                     |
| `into`           | Literal text separating the source and target branches.                                                             |
| `.?develop.?`    | The target branch, with an optional character on each side, so that both `into 'develop'` and `into develop` match. |
| `\|`             | Alternation: either the part on its left or the part on its right matches.                                          |
| `(publication)`  | The word `publication` anywhere in the message.                                                                     |

For example, these messages trigger the job on `develop`:

```text
Merge branch 'mike-pages-inquiry' into 'develop'
Fix typo in antenna page (publication)
```

Behavior to be aware of:

- The branch condition is still applied: the job only runs when the pipeline is on `publication_branch`. A merge message pushed on another branch does not trigger it.
- The expression has no end anchor on purpose: the merge commit message continues on the following lines (merge request title, `See merge request ...`).
- The first alternative only works with the **merge commit** method. With squash or fast-forward merges, the message does not start with `Merge branch`, and only the `publication` alternative can trigger the job. Check the method in **Settings > Merge requests**.
- In `both` mode (or `merge_request` mode), the same expression is also matched against the merge request title and description, and the commit message of the merge request pipeline. A `publication` in the title or description triggers a `mr-<iid>` preview.
- The match is case-sensitive.
- Avoid `/` and `'` in the expression. The value is inserted between `/.../` delimiters inside a single-quoted rule, so these characters break the rule. Use `.?` instead of a quote, as in the example.
- Write the whole value between double quotes in the YAML, and escape regular expression special characters you want to match literally (for example `\[docs\]`).

Further triggers can be added with additional `|` alternatives.

### Published versions

The documentation version is selected as follows:

| Context                  | Version published | `latest` alias and default version |
| ------------------------ | ----------------- | ---------------------------------- |
| Tagged commit            | The Git tag       | Updated                            |
| Untagged commit (branch) | `dev`             | Updated                            |
| Merge request pipeline   | `mr-<iid>`        | Not modified                       |

### MkDocs and Mike configuration

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

## 📂 Jobs

| Job          | Description                                                                                                                                                                                                                                                                      |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `mike_pages` | Builds and publishes versioned MkDocs documentation using Mike, then exports the published site as the `public/` artifact for GitLab Pages. Runs in the stage given by `pages_stage`, according to `job_execution_mode` and the publication rules described in [Usage](#-usage). |

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
8. **Project path and configuration file**: The job runs `cd "$CI_PROJECT_DIR/$mk_path"`, then looks for `mkdocs_config_file` and `requirements.txt` in that directory. The error `MkDocs configuration not found` means that the file is not at the expected location.

### Publication branch

The `mike_branch` input defaults to `pages/mike`.

This is an ordinary Git branch dedicated to storing the versioned documentation generated by Mike. The `pages/` prefix does not provide any special behavior in GitLab.

The job checks whether the remote branch exists. If it does not, the job creates it from an **empty commit** (an empty tree, with no source files). Mike then adds the generated documentation and pushes the result.

The branch must contain **only the generated site**:

```text
pages/mike
├── <version>/        # one directory per published version (dev, v1.0, mr-11, ...)
├── versions.json
├── index.html        # redirect to the default version (created with the default version)
└── .nojekyll
```

The content of this branch is exported as-is to GitLab Pages. If it also contains project sources (`docs/`, `mkdocs.yml`, `.gitlab-ci.yml`, scripts, ...), they are **published publicly with the documentation**. This happens when the branch was created from a source commit instead of an empty one. In that case, delete the branch and run the pipeline again so that it is recreated empty.

Avoid modifying this branch manually unless you intend to change the published documentation history.

### First deployment

The `latest` alias and the redirect from the site root to `latest/` are only created by a **non-merge-request** deployment, that is, a commit containing the keyword on `publication_branch`, or a tag.

Until then:

- only the `mr-<iid>` versions exist;
- `https://<namespace>.pages.<host>/<project>/latest/` returns a 404;
- the site root has no redirect.

With `job_execution_mode: "merge_request"` alone, `latest` is never created. Use `branch` or `both` and publish at least once from `publication_branch` or with a tag.

Without a tag, `latest` points to `dev`. With a tag (for example `v1.0`), it points to that tag. Publish with tags if you want a stable `latest`.

---

## 🪝 Pre-commit Configuration

Pre-commit hooks help keep the template and its documentation valid before each commit.

Install pre-commit and enable the hooks in your clone:

```bash
pip install pre-commit
pre-commit install
```

Minimal `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
        args: [--allow-multiple-documents]
```

The `--allow-multiple-documents` argument is required because `template.yml` separates `spec:` from the job configuration with `---`.

---

## 💻 Local Usage

The `mike_pages` job itself relies on CI variables (`CI_JOB_TOKEN`, `CI_COMMIT_SHA`, ...) and cannot be run as-is outside GitLab CI/CD. The documentation, however, can be built and previewed locally with the same tools.

Requirements: Python 3 and Git.

```bash
cd docs                                  # the directory given by mk_path
python -m venv .venv
source .venv/bin/activate                # Windows: .venv\Scripts\activate
python -m pip install -r requirements.txt

# Live preview of the current documentation
mkdocs serve -f mkdocs.yml
```

To test the versioned output without pushing anything, use a local branch:

```bash
mike deploy --branch pages/mike-local dev
mike serve --branch pages/mike-local
```

Without `--push`, Mike only commits to the local branch. Delete it afterwards with `git branch -D pages/mike-local`.

---

## 🔌 VS Code Extensions

- [GitLab Workflow](https://marketplace.visualstudio.com/items?itemName=GitLab.gitlab-workflow): validates `.gitlab-ci.yml` against your GitLab instance and shows pipeline status.
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml): syntax checking and validation for YAML files.
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode): consistent formatting of YAML and Markdown files.
- [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint): lints the README and documentation pages.

---

## 🔗 References

- [Mike documentation](https://github.com/jimporter/mike)
- [MkDocs documentation](https://www.mkdocs.org/)
- [GitLab CI/CD components](https://docs.gitlab.com/ci/components/)
- [GitLab Pages](https://docs.gitlab.com/user/project/pages/)
- [GitLab CI/CD job token](https://docs.gitlab.com/ci/jobs/ci_job_token/)
- [GitLab merge request pipelines](https://docs.gitlab.com/ci/pipelines/merge_request_pipelines/)
- [pre-commit](https://pre-commit.com/)
