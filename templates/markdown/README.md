# MarkdownLint CI Template (GitLab CI)

This template adds a GitLab CI job to lint Markdown files using `markdownlint-cli`.

It is designed to be reusable across projects and runs in a Node.js container (Node 20).

## What it does

- Installs `markdownlint-cli` at job runtime
- Lints Markdown files under a configurable directory (`MD_PATH`)
- Uses `.markdownlint.json` for rules
- Uses `.markdownlintignore` for exclusions (automatically read by markdownlint-cli)

## How to integrate

### 1) Include the template in your `.gitlab-ci.yml`

If you use this repository as a central templates repo, include the component like this:

```yaml
include:
  - project: "iphc/ci-templates"
    ref: "develop" # or a tag / stable ref
    file: "templates/markdownlint/template.yml"
```

If your organization uses another project path or ref, adjust accordingly.

### 2) Ensure you have a `lint` stage

The job runs in the `lint` stage. Make sure your pipeline defines it:

```yaml
stages:
  - lint
```

### How to use

By default, the template lints all Markdown files under `MD_PATH` (defaults to `.`).

#### Lint the whole repository (recommended)

```yaml
variables:
  MD_PATH: "."
```

#### Lint only documentation

```yaml
variables:
MD_PATH: "docs"
```

#### Required configuration files

Place these files at the **repository root**:

`.markdownlint.json` **(required)**

Example minimal config:

```json
{
  "default": true,
  "MD013": false
}
```

`.markdownlintignore` **(recommended)**

Example:

```text
node_modules/
**/node_modules/
public/
dist/
build/
.pio/
.git/
```

`markdownlint-cli` automatically reads `.markdownlintignore` if present.

#### Template job name

The template exposes a concrete job named:

- `Markdown Lint`

If you want a different name, you can define your own job extending the hidden template (see below).

### Advanced: Custom job (rules, allow_failure, etc.)

You can extend the hidden job template and add your own rules:

```yaml
Markdown Lint (custom):
  extends: .markdown-lint-template
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: on_success
    - when: never
```

The hidden template is called `.markdown-lint-template`.

### Troubleshooting

#### It lints vendor/generated directories

Add them to `.markdownlintignore`, e.g. `node_modules/`.

#### Job fails due to Node compatibility

This template runs with `node:20` by default.

#### No Markdown files found

Check `MD_PATH` and ensure it points to the correct folder.

### Notes

- The job installs dependencies at runtime (`npm i -D markdownlint-cli`).

- Keep `.markdownlint.json` and `.markdownlintignore` in the repo root for consistent behavior across projects.
