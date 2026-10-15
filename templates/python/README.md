# Python Linting

This GitLab CI template provides reusable jobs for linting Python code. It supports the following tools:

- **isort**: Sort Python imports.
- **black**: Format Python code.
- **flake8**: Enforce Python style guidelines.
- **pylint**: Perform static code analysis.

Each tool can be **individually enabled or disabled** via input variables.

---

## 📌 Features

- **Modular Linting**: Enable or disable each tool (`isort`, `black`, `flake8`, `pylint`) independently.
- **Configurable**: Customize paths (e.g., `PYLINT_RCFILE`) and behavior via inputs.
- **Reusable**: Designed as a GitLab CI/CD component for easy integration.
- **Consistent**: Uses the latest Python Docker image for reproducibility.

---

## 🔧 Prerequisites

- A GitLab project with **GitLab CI/CD enabled**.
- Python files in the repository (required for `pylint`).
- A valid `pyproject.toml` or custom configuration file (if `RUN_PYLINT` is `true`).

---

## 📥 Inputs

| Input           | Description                            | Default Value    | Required |
| --------------- | -------------------------------------- | ---------------- | -------- |
| `RUN_ISORT`     | Enable/disable isort linting.          | `true`           | No       |
| `RUN_BLACK`     | Enable/disable black linting.          | `true`           | No       |
| `RUN_FLAKE8`    | Enable/disable flake8 linting.         | `true`           | No       |
| `RUN_PYLINT`    | Enable/disable pylint linting.         | `true`           | No       |
| `PYLINT_RCFILE` | Path to the pylint configuration file. | `pyproject.toml` | No       |

---

## 🚀 Usage

### Basic Example

Include the component in your `.gitlab-ci.yml`:

```yaml
include:
  - component: templates/python/template.yml
```

### Advanced Example

Disable specific tools:

```yaml
include:
  - component: templates/python/template.yml
    inputs:
      RUN_BLACK: "false"
      RUN_PYLINT: "false"
      PYLINT_RCFILE: "custom_pylint.cfg"
```

---

## 📂 Jobs

| Job      | Description                    |
| -------- | ------------------------------ |
| `isort`  | Checks Python import sorting.  |
| `black`  | Checks Python code formatting. |
| `flake8` | Checks Python code style.      |
| `pylint` | Performs static code analysis. |

All jobs run in the `lint` stage and use the `python:3.14-slim` Docker image.

---

## 🔐 Authentication

No additional authentication is required for this component.

---

## ⚠️ Notes

- If no Python files are found, the `pylint` job will exit gracefully with a message.
- Ensure Python files are committed and not ignored by `.gitignore`.
- For custom configurations (e.g., `pylint`), provide the path to your configuration file via `PYLINT_RCFILE`.

---

## 🪝 Pre-commit Configuration

This component supports local development using **pre-commit** hooks for Python linting.
To set up pre-commit for this template, follow these steps:

1. Install pre-commit:

   ```bash
   pip install pre-commit
   ```

1. Create or update your `.pre-commit-config.yaml` with the following configuration:

   ```yaml
   default_language_version:
     python: python3.14

   repos:
     # Python Linting Tools
     - repo: https://github.com/psf/black
       rev: 23.12.1
       hooks:
         - id: black
           language_version: python3.14

     - repo: https://github.com/PyCQA/isort
       rev: 5.13.2
       hooks:
         - id: isort
           args: ["--profile=black", "--line-length=120"]

     - repo: https://github.com/PyCQA/flake8
       rev: 6.1.0
       hooks:
         - id: flake8
           args: ["--max-line-length=120", "--ignore=E203,W503"]

     - repo: https://github.com/pycqa/pylint
       rev: v3.0.3
       hooks:
         - id: pylint
           args: ["--rcfile=pyproject.toml"]
   ```

1. Install the hooks:

   ```bash
   pre-commit install
   ```

1. Run pre-commit manually:

   ```bash
   pre-commit run --all-files
   ```

---

## 💻 Local Usage

To test the template locally:

1. Clone the repository.
2. Ensure Docker is installed and running.
3. Run the jobs manually using `docker` or a local Python environment:

   ```bash
   docker run --rm -v $(pwd):/app python:3.14-slim bash -c "cd /app && pip install isort black flake8 pylint && isort --check . && black --check . && flake8 . && pylint --rcfile=pyproject.toml ."
   ```

---

## 🔌 VS Code Extensions

Recommended extensions for Python linting:

- **[Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)**: Official Python extension for VS Code.
- **[Pylint](https://marketplace.visualstudio.com/items?itemName=ms-python.pylint)**: Integrates pylint into VS Code.
- **[Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)**: Auto-format Python code using Black.
- **[isort](https://marketplace.visualstudio.com/items?itemName=ms-python.isort)**: Sort Python imports using isort.

---

## 🔗 References

- [GitLab CI/CD Components](https://docs.gitlab.com/ee/ci/components/)
- [isort Documentation](https://pycqa.github.io/isort/)
- [Black Documentation](https://black.readthedocs.io/)
- [Flake8 Documentation](https://flake8.pycqa.org/)
- [Pylint Documentation](https://pylint.readthedocs.io/)
