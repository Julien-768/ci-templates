# GitLab CI Python Windows Installer Template – Documentation

This documentation explains how to use the **Python Windows Installer** component provided by `iphc/ci-templates` to build a Windows `.exe` installer for Python GUI applications using **PyInstaller** and **Inno Setup**.

---

## ✅ What it does

This template automates the creation of a **Windows installer** (`.exe`) for Python applications. It performs the following steps:

1. **Installs dependencies** (Wine, Python, PyInstaller, Inno Setup).
2. **Builds the executable** using PyInstaller from a `.spec` file.
3. **Creates an installer** using Inno Setup from a `.iss` script.
4. **Outputs the installer** (`.exe`) in the specified directory.

The template provides **one hidden job**:

- **`.windows-installer-template`**: Reusable job for building Windows installers.

And **one concrete job**:

- **`windows-installer`**: Extends the template to build the installer for your project.

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - project: 'iphc/ci-templates'
    file: '/templates/python-windows-installer/template.yml'
    ref: 'feature/installer-windows'  # or 'main'/'develop' depending on your setup
    inputs:
      stage: build
      image: python:3.13-slim
      project_dir: "."
      pyinstaller_spec: "rfid_door_gui.spec"
      inno_script: "packaging/windows/installer.iss"
      output_dir: "release"
      app_version: "\$CI_COMMIT_TAG"  # Optional: Dynamic version from Git tag
```

Define the stages in this order:

```yaml
stages:
  - build
```

No additional job definition is required locally.
Including the component is sufficient to enable Windows installer builds.

---

## 🔧 Inputs

| Input            | Description                                        | Default                         |
| ---------------- | -------------------------------------------------- | ------------------------------- |
| stage            | CI stage used for the installer job.               | build                           |
| image            | Docker image used for building the installer.      | python:3.13-slim                |
| project_dir      | Root directory of the project.                     | .                               |
| pyinstaller_spec | Path to the PyInstaller .spec file.                | rfid_door_gui.spec              |
| inno_script      | Path to the Inno Setup .iss script.                | packaging/windows/installer.iss |
| output_dir       | Directory where the installer will be saved.       | release                         |
| app_version      | Version of the application (passed to Inno Setup). | 0.1.0                           |

Example:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/python-windows-installer/template.yml"
    ref: "feature/installer-windows"
    inputs:
      pyinstaller_spec: "my_app.spec"
      inno_script: "installer/my_installer.iss"
      app_version: "1.0.0"
```

---

## 🧠 Important Notes

- **Wine Configuration:** This template requires **Wine** to run PyInstaller and Inno Setup on Linux runners.
- **Python Version:** The template uses Python 3.13 by default. Ensure your project is compatible.
- **Inno Setup:** The `.iss` script must be compatible with Inno Setup 6. The template passes the `app_version` variable via the command line (`/dAppVersion=$CI_COMMIT_TAG`).
- **PyInstaller Spec File:** The `.spec` file must correctly reference all assets (e.g., icons, data files).
- **Output:** The installer (`.exe`) is saved in the `output_dir` and uploaded as a CI artifact.

---

## 📦 Outputs

The job generates the following artifacts:

- A **Windows installer** (`.exe`) in the specified `output_dir` (default: `release/`).
- The artifact is available for download in the GitLab CI job.

---

## 🔗 Dependencies

- **PyInstaller:** Used to build the executable from Python source.
- **Inno Setup:** Used to create the Windows installer.
- **Wine:** Required to run Windows tools on Linux runners.

---

## 💡 Example Usage

Minimal `.gitlab-ci.yml:`

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/python-windows-installer/template.yml"
    ref: "feature/installer-windows"
    inputs:
      stage: build

stages:
  - build

build-installer:
  extends: .windows-installer-template
  rules:
```

With Custom Version:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/python-windows-installer/template.yml"
    ref: "feature/installer-windows"
    inputs:
      app_version: "2.0.0"
```
