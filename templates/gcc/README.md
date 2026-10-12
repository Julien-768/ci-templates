# GCC Embedded

Shared GitLab CI component for building embedded firmware with the [GNU Arm Embedded Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

This component installs the required build tools and runs a Makefile-based firmware build.

---

## 📌 Features

- **Compilation**: Builds embedded firmware using `arm-none-eabi-gcc` and GNU Make.
- **Toolchain Installation**: Installs the GNU Arm Embedded Toolchain and required supporting packages.
- **Makefile Validation**: Checks that the specified project directory contains a `Makefile`.
- **Configurable**: Supports custom build stages, SDK paths, and additional Make arguments.
- **Pipeline Integration**: Fails the GitLab CI pipeline if the Makefile is missing or the build fails.

---

## 🔧 Prerequisites

- An embedded firmware project with a GNU Make-compatible `Makefile`.
- A project directory specified through `gcc_make_dir`.
- Any SDK or project-specific dependencies required by the build.
- A GitLab Runner capable of running the `debian:stable-slim` Docker image.

---

## 📥 Inputs

| Input             | Description                                                | Default | Required |
| ----------------- | ---------------------------------------------------------- | ------- | -------- |
| `stage`           | CI stage used for the firmware build job.                  | `build` | No       |
| `gcc_make_dir`    | Directory containing the Makefile to build.                | None    | Yes      |
| `sdk_path`        | SDK path forwarded to Make as `SDK_PATH`.                  | `""`    | No       |
| `extra_make_args` | Additional Make arguments, such as `TARGET=foo VERBOSE=1`. | `""`    | No       |

---

## 🚀 Usage

### Basic Example

Include the component in your `.gitlab-ci.yml` file:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/gcc/template.yml"
    ref: "<commit-sha>"
    inputs:
      gcc_make_dir: "firmware"
```

### Advanced Example

Customize the firmware build with specific inputs:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/gcc/template.yml"
    ref: "<commit-sha>"
    inputs:
      stage: build
      gcc_make_dir: "firmware"
      sdk_path: "/opt/arm-sdk"
      extra_make_args: "TARGET=my_board VERBOSE=1"
```

Replace `firmware`, `/opt/arm-sdk`, and the Make arguments with values appropriate for your project.

---

## 📂 Jobs

| Job            | Description                                                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `gcc-embedded` | Installs the GNU Arm Embedded Toolchain, validates the Makefile location, and builds the firmware. Fails the pipeline if the build fails. |

---

## 🔐 Authentication

No additional authentication is required by the component itself. Access to the component repository must be available to the GitLab pipeline.

---

## ⚠️ Notes

- **Toolchain**: The component installs `gcc-arm-none-eabi`, `binutils-arm-none-eabi`, `libnewlib-arm-none-eabi`, `make`, and `ca-certificates`.

- **Makefile Location**: The `gcc_make_dir` input must point to a directory containing a file named `Makefile`.

- **SDK Path**: The `sdk_path` input is forwarded to Make as `SDK_PATH`. The project's Makefile must support this variable if it is required.

- **Additional Arguments**: Use `extra_make_args` to pass simple Make arguments, for example `TARGET=my_board VERBOSE=1`.

- **Reproducibility**: The component uses `debian:stable-slim` and installs packages at runtime. Package versions may change over time.

- **Local Testing**: Run the equivalent Make command locally to validate the build before pushing changes. For example:

  ```bash
  make -C firmware SDK_PATH=/opt/arm-sdk TARGET=my_board VERBOSE=1
  ```

- **Build Failures**: The pipeline fails if the Makefile is missing, package installation fails, or Make returns a non-zero exit status.

- **Artifacts**: The component does not declare or publish build artifacts by default.

---

## 🔗 References

- [GNU Arm Embedded Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [GitLab CI/CD Components](https://docs.gitlab.com/ee/ci/components/)
