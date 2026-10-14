# MkDocs

Reusable GitLab CI/CD component for building MkDocs documentation and publishing it through GitLab Pages when a commit on the configured publication branch contains the configured keyword.

---

## 📌 Features

- **Strict Documentation Build:** Runs `mkdocs build --strict --verbose`.
- **Validation Job:** Builds the site into `test/` in the configured test stage.
- **GitLab Pages Publication:** Builds the site into `public/` and exposes it as a Pages deployment job.
- **Configurable Project Path:** Supports documentation stored in a subdirectory.
- **Configurable MkDocs Configuration:** Supports a configuration file relative to the documentation directory.
- **Controlled Publication:** Publication is limited to the configured branch and commit-message keyword.
- **Build Artifacts:** Retains generated output as CI artifacts for 24 hours.

---

## 🔧 Prerequisites

- A GitLab project containing an MkDocs project.
- A `requirements.txt` file in the directory selected by `mk_path`, listing MkDocs and required plugins/themes.
- A valid MkDocs configuration file, normally `mkdocs.yml`.
- A GitLab Runner able to run the configured Python Docker image and access the Python package index.
- The consuming pipeline must include the stages selected through `test_stage` and `pages_stage`.
- GitLab Pages must be available and enabled for the project if publication is required.

---

## 📥 Inputs

| Input                 | Description                                                     | Default       | Required |
| --------------------- | --------------------------------------------------------------- | ------------- | -------- |
| `mk_path`             | Directory containing the MkDocs project and `requirements.txt`. | `.`           | No       |
| `mkdocs_config_file`  | MkDocs configuration file, relative to `mk_path`.               | `mkdocs.yml`  | No       |
| `test_stage`          | Stage used by the documentation validation job.                 | `test`        | No       |
| `pages_stage`         | Stage used by the Pages publication job.                        | `deploy`      | No       |
| `publication_branch`  | Branch on which publication is permitted.                       | `develop`     | No       |
| `publication_keyword` | Keyword that must occur in the commit message.                  | `publication` | No       |

All inputs have defaults and are optional.

---

## 🚀 Usage

### Basic Example

Include the component directly from the shared repository:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/mkdocs@<version>"
```

Replace `iphc/ci-templates` with the actual project path if different, and replace `<version>` with a published catalog version. This syntax applies only after the component is published to the GitLab CI/CD Catalog.

If the component is consumed directly from a repository and is not published in the Catalog, use a file-based include instead:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mkdocs/template.yml"
    ref: "<commit-sha>"
```

Replace `<commit-sha>` with the desired commit SHA or Git reference.

### Advanced Example

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/mkdocs/template.yml"
    ref: "<commit-sha>"
    inputs:
      mk_path: "docs"
      mkdocs_config_file: "mkdocs.yml"
      test_stage: "test"
      pages_stage: "deploy"
      publication_branch: "develop"
      publication_keyword: "publication"

stages:
  - test
  - deploy
```

With this configuration, the component reads `docs/requirements.txt` and `docs/mkdocs.yml`. The Pages job runs only when the branch is `develop` and the commit message contains `publication`.

For publication to occur after a merge into `develop`, the resulting commit message on `develop` must contain the configured keyword. If the project uses squash merges or merge commits, check the actual commit message produced by the selected merge strategy.

---

## 📂 Jobs

| Job            | Description                                                                                                                                                                                                    |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `mkdocs_test`  | Installs documentation dependencies and builds the site in strict mode into `test/`. Runs in the stage selected by `test_stage`.                                                                               |
| `mkdocs_pages` | Installs documentation dependencies and builds the site in strict mode into `public/` for GitLab Pages. Runs in the stage selected by `pages_stage`, only when the branch and commit-message conditions match. |

Both jobs extend the hidden `.mkdocs-template` job. Each job installs dependencies and performs its own build; neither job depends on an upstream job.

Generated output is retained as a CI artifact for 24 hours.

---

## 🔐 Authentication

No additional authentication is required when all Python dependencies are available from a public package index.

The runner needs access to the Git repository and the package sources listed in `requirements.txt`. If private packages are required, configure credentials through GitLab CI/CD variables and the package index's recommended authentication mechanism.

GitLab Pages permissions and availability are governed by the consuming project's GitLab configuration. Never commit access tokens or passwords to the repository.

---

## ⚠️ Notes

- **Python Version:** The component uses `python:3.13`. Ensure the project's MkDocs dependencies support this version.
- **Dependency Reproducibility:** Pin package versions in `requirements.txt` for more reproducible builds.
- **Strict Mode:** Warnings can fail the build because MkDocs is run with `--strict`.
- **Publication Condition:** The Pages job requires both the configured branch and a commit message matching the configured keyword. The keyword is interpreted as a regular expression; use a simple keyword such as `publication` unless a more specific expression is required.
- **Commit Message Semantics:** The rule checks `CI_COMMIT_MESSAGE` for the commit that triggered the pipeline. Confirm that your merge strategy produces the expected commit message.
- **Stages:** The consuming pipeline must define the stages selected by `test_stage` and `pages_stage`. The default Pages stage is `deploy`, which is part of GitLab's default stage list.
- **Subdirectory Builds:** When `mk_path` is not `.`, the generated directory is moved to the project root so that the artifact path can be collected by GitLab CI.
- **Catalog Structure:** The component entry point must be `templates/mkdocs/template.yml`, with `spec:inputs` before `---` and jobs after it.
- **Validation:** Run GitLab CI Lint against the component and a consuming pipeline before merging changes.

---

## 🪝 Pre-commit Configuration

Pre-commit is optional. It can be used to check YAML formatting and basic file hygiene before committing.

Install pre-commit:

```bash
python -m pip install pre-commit
```

Add the following hooks to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
```

Install and run the hooks:

```bash
pre-commit install
pre-commit run --all-files
```

These hooks do not replace a real MkDocs build or GitLab CI validation.

---

## 💻 Local Usage

The component is designed for GitLab CI/CD, but its build commands can be run locally.

### Prerequisites

- Python 3.14 or another version supported by the project's dependencies.
- `pip`.
- An MkDocs project with `requirements.txt` and a configuration file.

### Build from the repository root

```bash
python -m pip install -r requirements.txt
python -m mkdocs build --strict --verbose --site-dir test -f mkdocs.yml
```

### Build from a documentation subdirectory

```bash
cd docs
python -m pip install -r requirements.txt
python -m mkdocs build --strict --verbose --site-dir test -f mkdocs.yml
```

To generate the Pages output locally, change `--site-dir test` to `--site-dir public`. The branch and commit-message publication rule is evaluated by GitLab CI and is not applied by the local build command.

---

## 🔌 VS Code Extensions

- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml): Provides YAML syntax support and validation for CI configuration files.
- [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python): Helps select Python environments and work with Python tooling.
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one): Provides Markdown editing shortcuts and preview support.
- [Markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint): Identifies common Markdown style issues.

These extensions improve editing but do not replace CI validation.

---

## 🔗 References

- [MkDocs Documentation](https://www.mkdocs.org/)
- [MkDocs Configuration](https://www.mkdocs.org/user-guide/configuration/)
- [MkDocs Command Line Interface](https://www.mkdocs.org/user-guide/cli/)
- [GitLab CI/CD Components](https://docs.gitlab.com/ci/components/)
- [GitLab CI/CD Inputs](https://docs.gitlab.com/ci/inputs/)
- [GitLab CI/CD YAML Syntax](https://docs.gitlab.com/ci/yaml/)
- [GitLab Pages](https://docs.gitlab.com/user/project/pages/)
- [GitLab CI Lint](https://docs.gitlab.com/ci/yaml/lint/)
- [pre-commit](https://pre-commit.com/)
