# Ruff

Shared GitLab CI component for linting and formatting Python code with [Ruff](https://docs.astral.sh/ruff/).
This component runs `ruff check` and `ruff format --check` to ensure code quality and consistency.

---

## 📌 Features

- **Linting**: Runs `ruff check .` to detect linting issues in Python code.
- **Formatting**: Runs `ruff format --check .` to verify code formatting compliance.
- **Read-only**: Does not modify files; only reports issues.
- **Configurable**: Supports custom Ruff versions, Python images, and project directories.
- **Pipeline Integration**: Fails the GitLab CI pipeline if linting or formatting issues are detected.

---

## 🔧 Prerequisites

- A **Python project** with source files in the specified `project_dir`.
- No additional tools or dependencies are required beyond Python and Ruff.

---

## 📥 Inputs

| Input          | Description                                                              | Default            | Required |
| -------------- | ------------------------------------------------------------------------ | ------------------ | -------- |
| `stage`        | CI stage used for the Ruff job.                                          | `lint`             | No       |
| `image`        | Python Docker image used to run Ruff.                                    | `python:3.13-slim` | No       |
| `project_dir`  | Root directory where Ruff commands are executed.                         | `.`                | No       |
| `ruff_version` | Optional Ruff version to install. Leave empty to use the latest version. | `""`               | No       |

---

## 🚀 Usage

### Basic Example

Include the component in your `.gitlab-ci.yml` file:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/ruff/template.yml"
    ref: "<commit-sha>"
```

### Advanced Example

Customize the Ruff job with specific inputs:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/ruff/template.yml"
    ref: "<commit-sha>"
    inputs:
      stage: test
      image: python:3.12-slim
      project_dir: "src"
      ruff_version: "0.15.18"
```

---

## 📂 Jobs

| Job  | Description                                                                         |
| ---- | ----------------------------------------------------------------------------------- |
| ruff | Runs Ruff linting and formatting checks. Fails the pipeline if issues are detected. |

---

## 🔐 Authentication

No additional authentication is required. The component relies solely on the GitLab CI environment.

---

## ⚠️ Notes

- **Ruff Configuration**: Ruff automatically loads configuration from `pyproject.toml` or `.ruff.toml` if present in the `project_dir`.
- **Reproducibility**: For consistent CI results, specify an explicit `ruff_version`.
- **Local Testing**: Run `ruff check .` and `ruff format --check .` locally to validate changes before pushing.
- **Fixing Issues**: Use `ruff check . --fix` and `ruff format .` to automatically fix linting and formatting issues.

---

## 🔗 References

- [Ruff Official Documentation](https://docs.astral.sh/ruff/)
- [GitLab CI/CD Components](https://docs.gitlab.com/ee/ci/components/)
- [Ruff GitHub Repository](https://github.com/astral-sh/ruff)
