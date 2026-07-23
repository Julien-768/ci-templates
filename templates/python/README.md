# Python Linting Template

## Description

This GitLab CI template provides reusable jobs for linting Python code. It supports the following tools:

- **isort**: Sort Python imports.
- **black**: Format Python code.
- **flake8**: Enforce Python style guidelines.
- **pylint**: Perform static code analysis.

Each tool can be **individually enabled or disabled** via input variables.

---

## Inputs

| Variable        | Description                            | Default Value    | Example Usage       |
| --------------- | -------------------------------------- | ---------------- | ------------------- |
| `RUN_ISORT`     | Enable/disable isort linting.          | `true`           | `false`             |
| `RUN_BLACK`     | Enable/disable black linting.          | `true`           | `false`             |
| `RUN_FLAKE8`    | Enable/disable flake8 linting.         | `true`           | `false`             |
| `RUN_PYLINT`    | Enable/disable pylint linting.         | `true`           | `false`             |
| `PYLINT_RCFILE` | Path to the pylint configuration file. | `pyproject.toml` | `custom_pylint.cfg` |

---

## Usage

### Basic Usage (All Tools Enabled)

Include the template in your `.gitlab-ci.yml` file:

```yaml
include:
  - component: templates/python/template.yml
```

### Custom Usage (Selective Tools)

Disable specific tools by setting their input variables to `false`:

```yaml
include:
  - component: templates/python/template.yml
    inputs:
      RUN_BLACK: "false"   # Disable black
      RUN_PYLINT: "false"  # Disable pylint
```

---

## Jobs

The template provides the following jobs:

- **`isort`**: Checks Python import sorting.
- **`black`**: Checks Python code formatting.
- **`flake8`**: Checks Python code style.
- **`pylint`**: Performs static code analysis.

All jobs run in the `lint` stage and use the `python:latest` Docker image.

---

## Requirements

- A GitLab project with **GitLab CI/CD enabled**.
- Python files in the repository (for `pylint` to work).
- A valid `pyproject.toml` or custom pylint configuration file (if `RUN_PYLINT` is `true`).

---

## Example Pipeline

Here’s an example of a `.gitlab-ci.yml` file using this template:

```yaml
stages:
  - lint

include:
  - component: templates/python/template.yml
    inputs:
      RUN_ISORT: "true"
      RUN_BLACK: "true"
      RUN_FLAKE8: "true"
      RUN_PYLINT: "false"  # Disable pylint
```

---

## Notes

- If no Python files are found, the `pylint` job will exit gracefully with a message.
- Ensure your Python files are committed and not ignored by `.gitignore`.
- For custom configurations (e.g., `pylint`), provide the path to your configuration file via `PYLINT_RCFILE`.
