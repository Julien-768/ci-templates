# GitLab CI Ruff Template – Documentation

This documentation explains how to use the Ruff component provided by `iphc/ci-templates` to lint and format Python source code.

## ✅ What it does

This template automates Python code quality checks using Ruff.

The template provides **one job**:

1. **`ruff`**

   - Installs Ruff.
   - Runs `ruff check .` to perform linting.
   - Runs `ruff format --check .` to verify formatting.
   - Fails the pipeline if linting or formatting issues are detected.

---

## 🔁 Pipeline Overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/ruff@$CI_COMMIT_SHA"
```

Define the stages in this order:

```yaml
stages:
  - lint
```

No additional job definition is required in the consuming project.

Including the component is sufficient to enable Ruff checks.

---

## 🔧 Inputs

| Input          | Description                                                         | Default            |
| -------------- | ------------------------------------------------------------------- | ------------------ |
| `stage`        | CI stage used for the Ruff job.                                     | `lint`             |
| `image`        | Python Docker image used to run Ruff.                               | `python:3.13-slim` |
| `project_dir`  | Root directory where Ruff commands are executed.                    | `.`                |
| `ruff_version` | Ruff version to install. Leave empty to install the latest version. | `""`               |

Example:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/ruff@$CI_COMMIT_SHA"
    inputs:
      image: python:3.13-slim
      project_dir: src
      ruff_version: "0.12.0"
```

---

## ⚠️ Requirements

The component expects at least one Python file to be present in `project_dir`.

If no Python files are found, Ruff will not perform any checks.

---

## 🧠 Important Notes

- Ruff configuration is automatically loaded from `pyproject.toml` when present.
- The component validates both linting and formatting.
- Formatting issues are reported but not automatically fixed.
- To automatically fix issues locally, run:

```bash
ruff check . --fix
ruff format .
```

---

## 🧪 Local Testing

A minimal Python file can be used to validate the component during CI testing:

```python
def hello() -> None:
    print("Hello Ruff")


if __name__ == "__main__":
    hello()
```

This ensures that both `ruff check` and `ruff format --check` are executed successfully during CI validation.

---

## 📦 Outputs

No artifacts are generated.

The job succeeds when:

- all linting checks pass;
- all files respect the configured formatting rules.
