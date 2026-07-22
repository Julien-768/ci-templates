# Markdown Lint

A **GitLab CI/CD Component Catalog** template for linting Markdown files using [`markdownlint-cli`](https://github.com/DavidAnson/markdownlint-cli).
This component ensures consistent Markdown formatting across your project.

---

## 📌 Usage

### Include the Component

Add this component to your `.gitlab-ci.yml`:

```yaml
include:
  - component: templates/markdownlint/template.yml
    inputs:
      MD_PATH: "." # Optional: Directory to lint (default: project root)
```

---

## ⚙️ Inputs

| Input     | Default | Description                                            |
| --------- | ------- | ------------------------------------------------------ |
| `MD_PATH` | `.`     | Root directory to lint (e.g., `"docs"` for docs only). |

---

## 📂 Required Files

Place these files in your **repository root** for the template to work:

### 1. `.markdownlint.json` _(Required)_

Defines the linting rules. Example:

```json
{
  "default": true,
  "MD013": false // Disable line length rule (80 chars)
}
```

### 2. `.markdownlintignore` _(Recommended)_

Excludes directories/files from linting. Example:

```text
node_modules/
**/node_modules/
.git/
dist/
build/
public/
.pio/
```

> **Note**: `markdownlint-cli` automatically reads `.markdownlintignore` if present.

---

## 🔧 Example Configurations

### Lint the Entire Repository

```yaml
include:
  - component: templates/markdownlint/template.yml
    inputs:
      MD_PATH: "."
```

### Lint Only Documentation

```yaml
include:
  - component: templates/markdownlint/template.yml
    inputs:
      MD_PATH: "docs"
```

---

## 🛠️ Customization

### Extend the Template

To customize the job (e.g., change `rules` or `allow_failure`), extend the hidden template:

```yaml
Markdown Lint (Custom):
  extends: .markdown-lint-template
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: on_success
    - when: never
```

> **Hidden Template Name**: `.markdown-lint-template`

---

## 🚨 Troubleshooting

### ❌ Lints `node_modules/` or Generated Files

**Solution**: Add them to `.markdownlintignore`:

```text
node_modules/
**/node_modules/
dist/
build/
```

### ❌ No Markdown Files Found

**Solution**: Verify `MD_PATH` points to a directory containing `.md` files.

---

---

## 📝 Notes

- For consistent behavior, place `.markdownlint.json` and `.markdownlintignore` in the **repository root**.
- This template follows the [GitLab CI/CD Component Catalog](https://docs.gitlab.com/ee/ci/components/) structure.
