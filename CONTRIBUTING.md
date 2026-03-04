# Contributing to CI Templates

Thank you for considering contributing to our CI Templates Component
Catalog repository.

This repository is structured as a **GitLab CI/CD Component Catalog**
project.\
Please read the following guidelines carefully before contributing.

---

## 🚀 Contribution Workflow

1.  **Fork the Repository**
2.  **Clone Your Fork**
3.  **Create a Feature Branch**
    - Use a descriptive name (e.g. `feat/clang-improvements`)
4.  **Implement Your Changes**
5.  **Validate Templates Locally**
6.  **Commit Changes**
    - Use clear and descriptive commit messages
7.  **Push Your Branch**
8.  **Create a Merge Request**
    - Target branch: `develop`
9.  **Address Review Feedback**
10. **Sync Your Fork After Merge**

---

## 📁 Repository Directory Structure (IMPORTANT)

This repository follows the **GitLab CI/CD Component Catalog
structure**.

All components MUST follow this exact layout:

    CI-TEMPLATES/
    ├── templates/
    │   ├── <component-name>/
    │   │   ├── template.yml
    │   │   └── README.md (optional but recommended)
    │   │
    │   ├── clang/
    │   │   ├── template.yml
    │   │   └── README.md
    │   │
    │   ├── python/
    │   │   ├── template.yml
    │   │   └── README.md
    │   │
    │   └── release/
    │       ├── template.yml
    │       └── README.md
    │
    ├── README.md
    └── CONTRIBUTING.md

## ⚠️ Mandatory Rules

- Components MUST be inside the `templates/` directory.
- Each component MUST have a directory.
- Each component directory MUST contain a file named **exactly**:
  `template.yml`

- Other filenames like:
  - `.gitlab-ci.yml`
  - `clang.gitlab-ci.yml`
  - `component.yml`

  ❌ are NOT valid for GitLab Component Catalog.

If this structure is not respected, GitLab will return:

    ```bash
    > Project must contain components. Ensure you are using the correct
    > directory structure
    ```

---

## 🧩 Template File Requirements (`template.yml`)

Each `template.yml` must:

1.  Contain a `spec:` section
2.  Be separated by `---`
3.  Define at least one job

## ✅ Minimal Valid Example

    ``` yaml
    spec:
    inputs:
        stage:
        default: build

    ---

    clang:
    stage: $[[ inputs.stage ]]
    script:
        - echo "Running clang"
    ```

If `spec:` is missing, the component will NOT be detected by GitLab.

---

## Template Headers

Each CI template file should include a header that describes the purpose of the template, any variables used, and their default values. Keep headers concise and limit them to a maximum of 10 lines to avoid excessive length.

For example:

    ```yaml
    # clang.gitlab-ci.yml
    #
    # Shared GitLab CI configuration for running clang-format and clang-tidy.
    #
    # Variables used by this template (optional unless stated otherwise):
    #
    # - CLANG_PATH:
    #   Directory to scan for C/C++ source files.
    #   Default: "."
    #
    # - CLANG_FORMAT_FILE:
    #   Path to the clang-format configuration file.
    #   Default: ".clang-format"
    ```

---

## 🏗 Design Principles

### The `ci-gitlab.yml`

The `ci-gitlab.yml` file must include all jobs from the template and must execute successfully for all jobs. This ensures that the CI pipeline is robust and all defined jobs are functioning correctly.

- **Reusable Components**
- **Clear Inputs**
- **Minimal Defaults**
- **Hidden Template Jobs**: Hidden template jobs (prefixed with a dot) define reusable building blocks.
- **Concrete Jobs**: Concrete jobs (e.g., `clang-format`, `clang-tidy`) are defined in this file so that consuming projects can simply include this template without redefining jobs.
- **Plug-and-Play**: Including this file is sufficient to get the default jobs executed.
- **No Project-Specific Logic**

Components must be generic and reusable across projects.

### Avoid before_script

Do not use before_script in catalog templates.
Why?

Unpredictable execution order and global side effects.
Reduces flexibility and reusability.
Introduces hidden dependencies and complicates debugging.

Instead:

Use hidden jobs (e.g., .setup_environment) or explicit script sections for reusable logic.
Ensures clarity, control, and maintainability.

---

## 🔐 Token Naming Recommendations

Use explicit and meaningful names:

- `CI_PUSH_TOKEN` → for pushing changes
- `CI_ACCESS_TOKEN` → for external services
- `CI_API_TOKEN` → for API-only access

Keep naming consistent and purpose-driven.

---

## ✍️ Commit Message Guidelines

Write clear and descriptive commit messages.

Recommended format:

    type(scope): short description

Example:

    feat(clang): add configurable source directory input

---

## ✅ CI Validation

All templates must:

- Be valid YAML
- Contain a proper `spec:` block
- Pass GitLab CI validation
- Not break existing components

---

## 📚 Documentation

Update the documentation to reflect any changes you make. This includes updating the headers in the template files and any relevant README files.

Each component SHOULD include:

- A short description
- Inputs explanation
- Example usage
- Required variables
- Default values

Keep documentation concise and clear.

---

## ❓ Questions

If you have any doubts about structure or catalog compatibility, contact
the repository maintainers before submitting large changes.

---

Happy contributing! 🚀
