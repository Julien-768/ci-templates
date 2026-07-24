# GitLab CI Sphinx Template – Documentation

This documentation explains how to use the **Sphinx** component provided by `iphc/ci-templates` to build HTML documentation for Python projects.

---

## ✅ What it does

This template automates the generation of **HTML documentation** using Sphinx.

The template provides **one job**:

1. **`sphinx-build`**
   - Installs Sphinx, a theme (e.g., `sphinx-book-theme`), and extensions (e.g., `sphinxcontrib-mermaid`).
   - Generates API documentation with `sphinx-apidoc`.
   - Builds HTML documentation with `sphinx-build`.
   - Stores the generated HTML documentation as a CI artifact.

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/sphinx/template.yml"
    ref: "develop"
    inputs:
      stage: build
      image: python:3.13-slim
      project_dir: "."
      python_source_dir: "src"
      source_dir: "src/docs/source"
      build_dir: "src/docs/build/html"
```

Ensure that the `build` stage is declared in your pipeline:

```yaml
stages:
  - build
```

No additional job definition is required locally.
Including the component is sufficient to enable Sphinx documentation builds.

---

## 🔧 Inputs

| Input               | Description                                            | Default                 |
| ------------------- | ------------------------------------------------------ | ----------------------- |
| `stage`             | CI stage used for the Sphinx build job.                | `build`                 |
| `image`             | Python Docker image used to run Sphinx.                | `python:3.13-slim`      |
| `project_dir`       | Root directory of the project.                         | `.`                     |
| `python_source_dir` | Directory containing Python source files.              | `src`                   |
| `source_dir`        | Sphinx source directory containing `conf.py`.          | `docs/source`           |
| `build_dir`         | Output directory for the generated HTML documentation. | `docs/build/html`       |
| `sphinx_version`    | Version of Sphinx to install.                          | `9.1.0`                 |
| `sphinx_theme`      | Sphinx theme to install.                               | `sphinx-book-theme`     |
| `sphinx_extensions` | Additional Sphinx extensions (space-separated).        | `sphinxcontrib-mermaid` |

**Example:**

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/sphinx/template.yml"
    ref: "develop"
    inputs:
      source_dir: "src/docs/source"
      build_dir: "src/docs/build/html"
      python_source_dir: "src"
```

## 📁 Recommended Project Layout

```text
.
├── src/
│   ├── main.py
│   └── docs/
│       ├── source/
│       │   ├── conf.py
│       │   └── index.rst
│       └── build/
│           └── html/
```

This layout matches the examples used throughout this documentation and the component defaults can be adjusted if a different structure is required.

## 🧠 Important Notes

- The `source_dir` must contain a valid `conf.py` file for Sphinx.
- The `project_dir` and `python_source_dir` must point to the Python source files to document.
- The `python_source_dir` directory must contain importable Python modules.
- `sphinx-apidoc` automatically generates `.rst` files from the Python sources before building the documentation.
- The generated documentation is stored as a CI artifact.
- Artifacts (HTML documentation) are saved for **1 week** by default.
- Publishing the documentation (for example with GitLab Pages) is handled separately.

## 📦 Outputs

- **Artifacts:** The built HTML documentation is available in the `build_dir` directory.
