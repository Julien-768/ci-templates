# GitLab CI Python Compile Template – Documentation

This documentation explains how to use the Python Compile component provided by `iphc/ci-templates` to validate Python source files.

## ✅ What it does

This template validates Python source files by compiling them.

The template provides **one job**:

1. **`python-compile`**
   - Installs the Python package using `pip install .`.
   - Compiles Python files using `compileall`.
   - Fails the pipeline if syntax errors are detected.

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/python-compile@$CI_COMMIT_SHA"
```

Define the stages in this order:

```yaml
stages:
  - test
```

No job definition is required locally.

Including the component is sufficient to enable Python compilation checks.

---

## 🔧 Inputs

| Input         | Description                                        | Default       |
| ------------- | -------------------------------------------------- | ------------- |
| `stage`       | CI stage used for the compile job.                 | `test`        |
| `image`       | Python Docker image used to run the compile check. | `python:3.12` |
| `project_dir` | Root directory of the Python project.              | `.`           |
| `source_dir`  | Python source directory to compile.                | `src`         |

Example:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/python-compile@$CI_COMMIT_SHA"
    inputs:
      source_dir: app
```

---

## 🧠 Important Notes

- The component requires a Python project installable through:

```bash
pip install .
```

- Compilation validates Python syntax but does not execute tests.
- Runtime errors are not detected by this component.
- This component is complementary to linting and unit testing.

---

## 📦 Outputs

No artifacts are generated.

The job succeeds when all Python files in the configured source directory can be compiled successfully.
