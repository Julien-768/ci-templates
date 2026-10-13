# ESLint & Prettier

Shared GitLab CI component for formatting and linting repository files using [Prettier](https://prettier.io/) and [ESLint](https://eslint.org/).

This component installs the required Node.js tooling and checks code formatting and lint rules to ensure consistent code quality across the repository.

---

## 📌 Features

- **Formatting:** Checks code formatting using Prettier.
- **Linting:** Runs ESLint with warnings treated as errors.
- **Multi-format Support:** Installs Prettier plugins for XML and Svelte, alongside ESLint plugins for Jest, Svelte, and GitLab.
- **Pipeline Integration:** Fails the GitLab CI pipeline if formatting or linting checks fail.
- **Automatic Tool Installation:** Installs the required Node.js tools at runtime.
- **Caching:** Caches `node_modules/` by Git branch to speed up subsequent pipeline runs.
- **Configurable Stage:** Allows the GitLab CI stage to be configured through a component input.

---

## 🔧 Prerequisites

- A GitLab repository containing source files supported by Prettier and/or ESLint.
- A GitLab Runner capable of running the `node:20-alpine` Docker image.
- Access to the npm registry to install the required tools and plugins.
- A GitLab CI configuration that includes this component.
- A compatible ESLint configuration in the target repository.

For local development, Node.js and npm must be installed. Pre-commit is optional but recommended for running checks before committing changes.

---

## 📥 Inputs

| Input   | Description                               | Default | Required |
| ------- | ----------------------------------------- | ------- | -------- |
| `stage` | CI stage used for formatting and linting. | `lint`  | No       |

The component uses the following built-in configuration:

| Setting                | Description                                | Value            |
| ---------------------- | ------------------------------------------ | ---------------- |
| `image`                | Node.js Docker image.                      | `node:20-alpine` |
| `ESLINT_NO_DEV_ERRORS` | ESLint environment variable.               | `"true"`         |
| `PRETTIER_CI`          | Prettier environment variable.             | `"true"`         |
| ESLint warnings        | Maximum number of allowed warnings.        | `0`              |
| Prettier mode          | Checks formatting without modifying files. | `--check`        |

---

## 🚀 Usage

### Basic Example

Include the component directly from the shared repository in your `.gitlab-ci.yml` file:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/eslint/template.yml"
    ref: "<commit-sha>"
```

Replace `<commit-sha>` with the commit SHA or Git reference corresponding to the version of the shared template you want to use.

The component adds the `eslint-prettier` job to the pipeline.

### Advanced Example: Custom Stage

The stage can be configured through the component input:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/eslint/template.yml"
    ref: "<commit-sha>"
    inputs:
      stage: lint
```

Replace `lint` with the desired stage name if necessary.

Ensure that the specified stage is defined in the project's `stages` list:

```yaml
stages:
  - lint
  - test
  - build
  - deploy
```

If your project already defines its stages, make sure the selected stage is included in the list.

**Distribution note** : These examples use a file-based include because the component is consumed directly from the iphc/ci-templates repository. If it is published and consumed through the GitLab CI/CD Catalog, use the corresponding include: component syntax and version reference instead.

---

## 📂 Jobs

| Job               | Description                                                                                                                      |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `eslint-prettier` | Installs the required Node.js tools, checks formatting with Prettier, and runs ESLint. Fails the pipeline if either check fails. |

The job uses the stage configured through the `stage` input, which defaults to `lint`.

The job has no upstream job dependencies because it defines empty `dependencies` and `needs` lists.

---

## 🔐 Authentication

No additional authentication is required by the component itself.

The GitLab Runner must have access to the repository containing the component and to the npm registry to retrieve the required packages.

If the project uses a private npm registry or private packages, configure the appropriate authentication separately using secure CI/CD variables or the registry's recommended authentication mechanism.

Never store registry credentials directly in the repository or in the component configuration.

---

## ⚠️ Notes

- **Node.js Environment:** The job runs in the `node:20-alpine` image.

- **Runtime Installation:** Prettier, ESLint, and their plugins are installed during the pipeline. Most packages use `latest`, so tool versions may change between pipeline runs.

- **ESLint Configuration:** The target repository must provide a compatible ESLint configuration and any additional dependencies required by it. Installing plugins does not automatically configure all their rules.

- **Prettier Plugins:** The component installs `@prettier/plugin-xml` and `prettier-plugin-svelte`. Depending on the project configuration and installed versions, explicit plugin configuration may be necessary.

- **ESLint Plugins:** The component installs `eslint-config-prettier`, `eslint-plugin-jest`, `eslint-plugin-svelte3`, `eslint-plugin-prettier`, and `@gitlab/eslint-plugin`.

- **Dependency Installation:** The job runs `npm install --save-dev` during CI. This may modify or create `package.json` and `package-lock.json` in the job workspace. These changes are not automatically committed to the repository.

- **Reproducibility:** Most package versions are not pinned. Pinning dependencies and using a committed lockfile is recommended for reproducible builds.

- **Caching:** The job caches `node_modules/` using `CI_COMMIT_REF_SLUG` as the cache key. Cache reuse depends on the GitLab Runner cache configuration.

- **Prettier Scope:** Prettier checks the repository using prettier --check --log-level=warn .. Files ignored by Prettier or excluded through configuration may not be checked.

- **ESLint Scope:** ESLint runs with eslint --max-warnings=0 .. The files checked depend on the ESLint configuration, ignore rules, and installed ESLint version.

- **Build Failures:** The pipeline fails if Prettier or ESLint returns a non-zero exit status.

- **Setup Commands:** The component uses before_script to disable npm funding and audit messages. This keeps the setup output focused on the installation and validation steps.

---

## 🪝 Pre-commit Configuration

Pre-commit can be used to run formatting and linting checks locally before committing changes.

Install pre-commit using the method recommended for your development environment. For example, with Python and pip:

```bash
    python -m pip install pre-commit
```

Add the following hooks to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: prettier-check
        name: Prettier check
        entry: prettier --check --log-level=warn .
        language: system
        pass_filenames: false
        always_run: true

      - id: eslint-check
        name: ESLint check
        entry: eslint --max-warnings=0 .
        language: system
        pass_filenames: false
        always_run: true
```

Install the hooks:

```bash
    pre-commit install
```

These hooks require Node.js, npm, Prettier, ESLint, and the plugins and configuration required by the project to be installed locally.

The commands above check the whole repository on each run. They do not install the component's dependencies automatically.

---

## 💻 Local Usage

The component is designed to run in GitLab CI/CD. Its checks can also be executed locally for development and troubleshooting.

### Prerequisites

- Node.js 20 and npm.
- Prettier and ESLint.
- The plugins required by the project.
- A compatible ESLint configuration.

Install the tools and plugins used by the component from the repository root:

```bash
    npm install --save-dev @prettier/plugin-xml
    npm install --save-dev eslint-config-prettier eslint-plugin-jest@^28.14.0 eslint-plugin-svelte3 eslint-plugin-prettier @gitlab/eslint-plugin
    npm install --save-dev prettier prettier-plugin-svelte eslint
```

Run the same checks as the CI job:

```bash
    npx prettier --check --log-level=warn .
    npx eslint --max-warnings=0 .
```

To fix formatting issues reported by Prettier, run:

```bash
    npx prettier --write .
```

Review the resulting changes before committing them.

**Note:** These commands use npm package version resolution from the current registry. For reproducible local and CI results, pin compatible package versions and maintain a lockfile. The ESLint plugins must also be configured appropriately for the project's ESLint version.

---

## 🔌 VS Code Extensions

The following VS Code extensions can help when editing and validating files checked by this component.

- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode): Provides Prettier formatting and editor integration.
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint): Provides ESLint diagnostics and linting integration in the editor.
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml): Provides YAML validation and editing support for GitLab CI configuration files.

These extensions improve the local editing experience but do not replace running the CI checks.

---

## 🔗 References

- [Prettier Documentation](https://prettier.io/docs/)
- [ESLint Documentation](https://eslint.org/docs/latest/)
- [GitLab CI/CD Components](https://docs.gitlab.com/ci/components/)
- [GitLab CI/CD Inputs](https://docs.gitlab.com/ci/inputs/)
- [pre-commit Documentation](https://pre-commit.com/)
- [Prettier VS Code Extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [ESLint VS Code Extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [YAML VS Code Extension](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
