# Contributing to CI Templates

Thank you for considering contributing to our **CI Templates Component Catalog** repository.

This repository is structured as a **GitLab CI/CD Component Catalog** project. Please read the following guidelines carefully before contributing.

---

## 🚀 Contribution Workflow

1. **Fork the Repository**
2. **Clone Your Fork**
3. **Create a Feature Branch**
   - Use a descriptive name (e.g., `feat/clang-improvements`).
4. **Implement Your Changes**
5. **Validate Templates Locally**
6. **Commit Changes**
   - Use clear and descriptive commit messages.
7. **Push Your Branch**
8. **Create a Merge Request**
   - Target branch: `develop`.
9. **Address Review Feedback**
10. **Sync Your Fork After Merge**

---

## 📁 Repository Directory Structure (IMPORTANT)

This repository follows the **GitLab CI/CD Component Catalog structure**.

All components MUST follow this exact layout:

```text
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
```

## ⚠️ Mandatory Rules

- Components MUST be inside the `templates/` directory.
- Each component MUST have its own directory.
- Each component directory MUST contain a file named **exactly** `template.yml`.

Other filenames, such as:

- `.gitlab-ci.yml`
- `clang.gitlab-ci.yml`
- `component.yml`

are **NOT** valid component entry-point filenames for the GitLab CI/CD Component Catalog structure described above.

If this structure is not respected, GitLab may return an error such as:

> Project must contain components. Ensure you are using the correct directory structure

---

## 🧩 Template File Requirements (`template.yml`)

Each `template.yml` must:

1. Contain a `spec:` section.
2. Separate the component specification from the main CI configuration using `---`.
3. Define at least one job.
4. Give each input a `description` field.
5. Reference inputs declared under `spec:inputs` explicitly using the `$[[ inputs.<name> ]]` syntax whenever they are used in the component configuration.

Inputs are **not** automatically available as regular CI/CD variables. When an input is used by a job, it must be explicitly referenced with `$[[ inputs.<name> ]]`.

### ✅ Minimal Valid Example

```yaml
spec:
  inputs:
    stage:
      default: build
      description: "CI stage used for the job."
---
.clang-template:
  stage: $[[ inputs.stage ]]
  variables:
    MY_VARIABLE: "example"
  script:
    - echo "Stage: $[[ inputs.stage ]]"
    - echo "Variable: $MY_VARIABLE"

clang:
  extends: .clang-template
```

If `spec:` is missing, the component will **NOT** be detected correctly by GitLab.

In this example:

- `stage` is an **input** declared under `spec:inputs` and referenced with `$[[ inputs.stage ]]`.
- `MY_VARIABLE` is a **CI/CD variable** and is referenced with `$MY_VARIABLE`.
- `.clang-template` is a hidden job containing reusable configuration.
- `clang` is the concrete job exposed to projects consuming the component.

---

## 📝 Template Headers

Each CI template file SHOULD include a header describing its purpose. Keep headers concise and limit them to a maximum of 10 lines.

Example:

```yaml
# clang/template.yml
#
# Shared GitLab CI configuration for running clang-format and clang-tidy.
```

---

## 🏗 Design Principles

### The `ci-gitlab.yml` File

The `ci-gitlab.yml` file must include all jobs from the component template and must execute successfully for all jobs. This ensures that the CI pipeline is robust and all defined jobs are functioning correctly.

Components SHOULD follow these principles:

- **Reusable Components:** Components should be reusable across multiple projects.
- **Clear Inputs:** Inputs should be named clearly and documented.
- **Minimal Defaults:** Provide sensible defaults without imposing unnecessary constraints.
- **Hidden Template Jobs:** Hidden jobs, prefixed with a dot, define reusable building blocks.
- **Concrete Jobs:** Concrete jobs (e.g., `clang-format`, `clang-tidy`) should be defined in the component so that consuming projects can include it without redefining those jobs.
- **Plug-and-Play:** Including the component should be sufficient to expose its documented jobs.
- **No Project-Specific Logic:** Components should avoid assumptions specific to one consuming project.

Components must be **generic** and reusable across projects.

### Hidden Template Jobs

When reusable job configuration is needed, components SHOULD define it in a hidden template job prefixed with a dot.

The corresponding concrete job MUST extend the hidden template job.

Example:

```yaml
.outils-template:
  image: alpine:latest
  script:
    - echo "Running tools"

outils:
  extends: .outils-template
```

The hidden template job contains the reusable implementation, while the concrete job defines the job exposed to consuming projects.

### Avoid `before_script`

Do **not** use `before_script` in catalog templates unless there is a documented reason to do so.

**Why?**

- It can introduce unexpected interactions with other configuration.
- It may reduce flexibility and reusability.
- It can introduce hidden dependencies and complicate debugging.

Instead, use hidden jobs (e.g., `.setup_environment`) or explicit `script` sections for reusable logic. This ensures clarity, control, and maintainability.

---

## 🔐 Token Naming Recommendations

Use explicit and meaningful names:

- `CI_PUSH_TOKEN` → for pushing changes.
- `CI_ACCESS_TOKEN` → for external services.
- `CI_API_TOKEN` → for API-only access.

Keep naming **consistent** and purpose-driven.

---

## ✍️ Commit Message Guidelines

Write clear and descriptive commit messages.

Recommended format:

```text
type(scope): short description
```

Example:

```text
feat(clang): add configurable source directory input
```

---

## ✅ CI Validation

All templates must:

- Be valid YAML.
- Contain a proper `spec:` block.
- Pass GitLab CI validation.
- Not break existing components.

---

## 📚 Documentation

Every component **MUST** have a `README.md` file following the standard structure defined below.

All component README files **MUST** use the same section names and order. This ensures consistent documentation across the entire Component Catalog and makes components easier to understand, compare, and maintain.

### Mandatory README Structure

Every component README **MUST** contain the following sections in the exact order listed below. Section headings, required content, and conditional requirements must be respected.

1. **Title and Description**

   - Use the format `# <Component Name>`.
   - Briefly describe the component's purpose, behavior, and intended use.

2. **📌 Features**

   - List the component's main features and capabilities.
   - Focus on functionality relevant to users of the component.

3. **🔧 Prerequisites**

   - Document all required tools, software, repository configuration, permissions, and dependencies.
   - Explicitly state when no prerequisites are required.

4. **📥 Inputs**

   - Document all component inputs in a table with the following columns: `Input`, `Description`, `Default`, and `Required`.
   - Include the input name, purpose, default value, and whether it is mandatory.
   - Explicitly state when the component has no inputs.

5. **🚀 Usage**

   - Provide a **Basic Example** showing how to include and use the component.
   - Provide an **Advanced Example** demonstrating relevant customization options.
   - If no advanced configuration is applicable, explicitly state this.
   - **Important:** The include syntax MUST match the component's intended distribution and consumption model. Use `include: component` for published GitLab CI/CD Catalog components and file-based includes when the component is intended to be consumed directly from a repository.

6. **📂 Jobs**

   - Document all concrete jobs exposed by the component in a table with the following columns: `Job` and `Description`.
   - Explain each job's purpose and relevant execution conditions, including applicable rules, stages, or dependencies.
   - If the component does not expose any concrete jobs, explicitly explain how it integrates into the pipeline and how it is intended to be used.

7. **🔐 Authentication**

   - Document authentication mechanisms, required tokens, CI/CD variables, permissions, and relevant GitLab settings.
   - Explain how credentials must be configured and any applicable security considerations.
   - Explicitly state when no additional authentication configuration is required.

8. **⚠️ Notes**

   - Document important limitations, configuration requirements, branch requirements, compatibility considerations, and troubleshooting guidance.
   - Explicitly state when no specific notes apply.

9. **🪝 Pre-commit Configuration**

   - If the component supports or benefits from pre-commit hooks, document how to install and configure them.
   - Include installation instructions and a minimal `.pre-commit-config.yaml` example.
   - Use only hooks relevant to the component and its development workflow.
   - If pre-commit is not applicable, explicitly state this.

   Example configuration:

   ```yaml
   repos:
     - repo: https://github.com/pre-commit/pre-commit-hooks
       rev: v4.4.0
       hooks:
         - id: trailing-whitespace
         - id: end-of-file-fixer
         - id: check-yaml
   ```

10. **💻 Local Usage**

    - Explain how to use the component locally for development and testing outside GitLab CI/CD.
    - Include the required tools, setup steps, and commands.
    - Provide practical examples of local execution when applicable.
    - If local execution is not supported, explain the limitation and describe available alternatives.

11. **🔌 VS Code Extensions**

    - List recommended VS Code extensions for developing, configuring, or testing the component.
    - Provide links to the corresponding extensions in the VS Code Marketplace.
    - Briefly explain the benefit of each extension.
    - If no specific extensions are relevant, explicitly state this.

12. **🔗 References**
    - Link to relevant official documentation, external tools, libraries, standards, and related resources.
    - Prefer authoritative and maintained sources.
    - Explicitly state when no external references are relevant.

#### General requirements

- Preserve the exact section order and numbering defined above.
- Use consistent Markdown formatting and valid code examples.
- Ensure that examples reflect the component's actual implementation and supported configuration.
- Do not document unsupported features, nonexistent jobs, or unverified configuration options.
- Where a section is conditionally applicable, retain the heading and explicitly explain why the content is not applicable.

### Documentation Rules

- All nine mandatory sections **MUST** be present in every component README, in the order specified above.
- Section headings **MUST** use the exact names listed above.
- Sections **MUST NOT** be renamed, reordered, or omitted.
- Additional subsections **MAY** be added within a mandatory section when necessary.
- Additional top-level sections **MUST NOT** be added without maintainer approval.
- Information **MUST** be accurate and consistent with the actual implementation in `template.yml` and the component's CI configuration.
- Input names, default values, required status, job names, authentication mechanisms, and execution rules **MUST** match the implementation.
- Examples **MUST** be valid YAML and representative of actual usage.
- Secrets **MUST NEVER** be included directly in examples. Use documented CI/CD variables instead.
- Documentation **MUST** be concise, clear, and technically accurate.
- All links **MUST** point to relevant and valid resources.

### Standardization and Validation

When adding a new component or modifying an existing one, contributors **MUST** create or update its `README.md` to comply with this standard.

Merge requests **SHOULD** be checked for consistency with the standard README structure before approval.

Keep documentation **consistent** across the entire Component Catalog.

---

## ❓ Questions

If you have any doubts about the repository structure or GitLab CI/CD Component Catalog compatibility, contact the repository maintainers before submitting large changes.

---

Happy contributing! 🚀
