# GitLab CI Clang Template – Documentation

This documentation explains how to use the Clang component provided by `iphc/ci-templates` to check C and C++ source code formatting with `clang-format` and run static analysis with `clang-tidy`.

## ✅ What it does

This template automates C and C++ code quality checks using LLVM Clang tools.

The template provides **two jobs**:

1. **`clang-format`**
   - Installs `clang-format` version 22.
   - Scans C and C++ source files.
   - Runs `clang-format --dry-run --Werror`.
   - Fails the pipeline when one or more files are not formatted according to the configured `.clang-format` file.

2. **`clang-tidy`**
   - Installs PlatformIO.
   - Runs `pio check` using `clang-tidy`.
   - Is automatically skipped when no `platformio.ini` file exists at the repository root.

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the following:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/clang@$CI_COMMIT_SHA"
```

Define the stages in this order:

```yaml
stages:
  - format
```

No job definition is required locally.

Including the component is sufficient to enable the Clang checks.

---

## 🔧 Variables

| Variable            | Description                                                 | Default               |
| ------------------- | ----------------------------------------------------------- | --------------------- |
| `CLANG_PATH`        | Directory or directories scanned by the `clang-format` job. | `.`                   |
| `CLANG_FORMAT_FILE` | Path to the `clang-format` configuration file.              | `.clang-format`       |
| `PIO_ENV`           | PlatformIO environment used by the `clang-tidy` job.        | `adafruit_feather_m0` |

Example:

```yaml
include:
  - component: "$CI_SERVER_FQDN/iphc/ci-templates/clang@$CI_COMMIT_SHA"

clang-format:
  variables:
    CLANG_PATH: "Logger/Sources Bootloader/sources"

clang-tidy:
  variables:
    PIO_ENV: "adafruit_feather_m0"
```

The `clang-format` job checks `.c` and `.h` files in the configured paths.

---

## 🧠 Important Notes

- The template uses `clang-format` version 22 from Alpine Linux.
- Formatting rules are loaded from `.clang-format` by default.
- The `clang-format` job only checks formatting; it does not modify files in the CI environment.
- The job fails when `clang-format` would modify a file.
- The default scan path is the repository root (`.`).
- Set `CLANG_PATH` to restrict checks to one or more directories.
- The `clang-tidy` job requires a `platformio.ini` file at the repository root.
- If no `platformio.ini` file is found, the `clang-tidy` job is skipped automatically.

To format files locally:

```bash
clang-format --style=file -i path/to/file.c
```

To check formatting locally without modifying files:

```bash
clang-format --dry-run --Werror --style=file path/to/file.c
```

To format all C and header files in selected directories:

```bash
find Logger/Sources Bootloader/sources \
  -type f \( -name '*.c' -o -name '*.h' \) \
  -exec clang-format --style=file -i {} +
```

---

## 📦 Outputs

No artifacts are generated.

The `clang-format` job succeeds when:

- all scanned files respect the configured `.clang-format` rules.

The `clang-tidy` job succeeds when:

- PlatformIO static analysis completes without reported errors.
