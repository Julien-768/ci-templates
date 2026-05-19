# PlatformIO GitLab CI Component

This documentation explains how to use the PlatformIO CI component provided by the CI Templates catalog
to automate firmware builds using PlatformIO.

## ✅ What it does

This component provides a reusable GitLab CI/CD job for embedded firmware projects using PlatformIO.

The component automatically:

- Installs PlatformIO Core
- Installs required system dependencies
- Detects the configured `platformio.ini`
- Builds all PlatformIO environments or selected environments

The template provides **one job**:

1. **`pio-build`**
   - Executes PlatformIO builds
   - Supports custom project directories
   - Supports custom PlatformIO configuration files
   - Optionally builds only selected environments

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - project: 'iphc/ci-templates'
    file: '/templates/platformio/template.yml'
    ref: '327f7427b319e949574807c798b88bc5d8adaf0f'
````

Define the stages in this order:

```yaml
stages:
  - build
```

No local job definition is required.

Including the component is sufficient to enable the PlatformIO build workflow.

---

## 🔧 Inputs you can override

| Input          | Description                                       | Default          |
| -------------- | ------------------------------------------------- | ---------------- |
| `stage`        | CI stage used for the PlatformIO build job        | `build`          |
| `project_conf` | Path to the PlatformIO configuration file         | `platformio.ini` |
| `project_dir`  | Root directory of the PlatformIO project          | `.`              |
| `environments` | Optional list of PlatformIO environments to build | `""`             |

---

## 📁 Custom PlatformIO Configuration

Use a custom `platformio.ini` location:

```yaml
include:
    - project: 'iphc/ci-templates'
      file: '/templates/platformio/template.yml'
      ref: '327f7427b319e949574807c798b88bc5d8adaf0f'
      inputs:
        project_conf: firmware/platformio.ini
```

---

## 📂 Custom Project Directory

Use a custom PlatformIO project root:

```yaml
      project_dir: firmware
```

---

## 🧩 Build Specific Environments

Build only selected PlatformIO environments:

```yaml
      environments: "esp32 debug"
```

This executes:

```bash
pio run --environment esp32
pio run --environment debug
```

---

## 🧠 Important Notes

- If `environments` is empty, all environments defined in `platformio.ini` are built.
- The job is skipped automatically if the configured `project_conf` file does not exist.
- The component installs:

  - Python dependencies
  - PlatformIO Core
  - Node.js (required by some PlatformIO platforms)

---

## 📦 Example Repository Layout

```text
project/
├── firmware/
│   ├── src/
│   └── platformio.ini
└── .gitlab-ci.yml
```

Example include:

```yaml
include:
  - component: $CI_SERVER_FQDN/group/ci-templates/platformio@main
    inputs:
      project_dir: firmware
      project_conf: firmware/platformio.ini
```

---

## ✅ Requirements

Projects using this component must contain:

- A valid `platformio.ini`
- At least one PlatformIO environment

Example:

```ini
[env:esp32]
platform = espressif32
board = esp32dev
framework = arduino
```

---

## 📚 Documentation

The component follows the GitLab CI/CD Component Catalog structure and conventions.

---

## 📄 License

MIT
