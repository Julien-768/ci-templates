# GitLab CI Python Windows Installer Template – Documentation

This documentation explains how to use the **Python Windows Installer** component provided by `iphc/ci-templates` to build a Windows `.exe` installer for Python GUI applications using **PyInstaller** and **Inno Setup**.

---

## ✅ What it does

This template automates the creation of a Windows installer (`.exe`) for Python applications. It:

1. Installs the required build tools.
2. Builds the executable using PyInstaller from a `.spec` file.
3. Creates an installer using Inno Setup from a `.iss` script.
4. Publishes the generated installer as a CI artifact.

The component provides:

- **`.windows-installer-template`**: Reusable job for building Windows installers.
- **`windows-installer`**: Concrete job that extends the template.

---

## 🔁 Pipeline overview

Include the component in your `.gitlab-ci.yml`:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/python-windows-installer/template.yml"
    ref: "feature/installer-windows" # Use "main" or "develop" when appropriate
    inputs:
      stage: build
      image: python:3.13-slim
      project_dir: "."
      pyinstaller_spec: "rfid_door_gui.spec"
      inno_script: "packaging/windows/installer.iss"
      output_dir: "release"
      app_version: "$CI_COMMIT_TAG" # Use this only in tag pipelines

stages:
  - build
```

No additional job definition is required locally. Including the component is sufficient to enable Windows installer builds.

---

## 🔧 Inputs

| Input              | Description                                   | Default                           |
| ------------------ | --------------------------------------------- | --------------------------------- |
| `stage`            | CI stage used for the installer job.          | `build`                           |
| `image`            | Docker image used for building the installer. | `python:3.13-slim`                |
| `project_dir`      | Root directory of the project.                | `.`                               |
| `pyinstaller_spec` | Path to the PyInstaller `.spec` file.         | `rfid_door_gui.spec`              |
| `inno_script`      | Path to the Inno Setup `.iss` script.         | `packaging/windows/installer.iss` |
| `output_dir`       | Directory where the installer is saved.       | `release`                         |
| `app_version`      | Application version passed to Inno Setup.     | `0.1.0`                           |

---

## 🧠 Important Notes

- **Python compatibility:** The default image uses Python 3.13. Ensure that your application and its dependencies are compatible with this version.

- **Inno Setup and application version:** The `.iss` script must be compatible with Inno Setup 6. The template passes the value of the `app_version` input to Inno Setup through the command line:

  ```text
  /dAppVersion=<app_version>
  ```

  The `app_version` input is optional and defaults to `0.1.0`. It can be set to a fixed value or to a CI variable. `$CI_COMMIT_TAG` should only be used in tag pipelines; the installer template also works independently of any release template.

---

## 📦 Outputs

The job generates a Windows installer (`.exe`) in the configured `output_dir` (default: `release/`).

The artifact is available for download from the GitLab CI job.
