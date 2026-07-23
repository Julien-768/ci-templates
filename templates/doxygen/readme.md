# GitLab CI Doxygen Component – Documentation

This documentation explains how to use the `doxygen` component provided by `iphc/ci-templates`
to generate and publish Doxygen documentation using GitLab Pages.

## ✅ What it does

The component provides a **`doxygen` job** that:

- Runs Doxygen using a project-provided configuration

- Automatically downloads a shared `Doxyfile.base`

- Generates HTML documentation

- Publishes the output as GitLab Pages artifacts

- Runs only when explicitly requested via commit message

---

## 🔁 Pipeline overview

The `.gitlab-ci.yml` must include the component:

```yaml
include:
  - project: "iphc/ci-templates"
    file: "/templates/doxygen/template.yml"
    ref: "<commit-sha>"
    inputs:
      doxyfile_path: "."
```

Define the stages including pages:

```yaml
stages:
  - pages
```

No job definition is required locally.

Including the component is sufficient to enable documentation generation.

## 🔧 Inputs

- `doxyfile_path` _(optional)_ – Path to the directory containing the `doxygen/` folder (`.` by default)

## 📁 Expected Project Structure

Each project must provide its own Doxygen configuration:

```ascii
<project-root>/
└── doxygen/
    ├── Doxyfile
    └── ...
```

The project `Doxyfile` must include the shared base configuration:

```ascii
@INCLUDE = Doxyfile.base
```

## ▶️ Triggering Documentation

The job runs only when the commit message contains:

```ascii
publication
```

Example:

```bash
git commit -m "docs: update API documentation publication"
```

## 📦 Outputs

- Artifact: public/ (GitLab Pages content)

- Generated HTML documentation is available via GitLab Pages if enabled

## 🧠 Important Notes

- The job runs in an Alpine container with:

- `doxygen`

- `graphviz`

- `curl`

- The shared Doxyfile.base is fetched from the ci-templates repository

- The component is trigger-based (not automatic on every commit)

- Designed to be reusable and project-agnostic

### ⚠️ Behavior Notes

- The job is skipped:

  - on tag pipelines

  - if the commit message does not contain publication

- The job publishes artifacts but does not configure GitLab Pages itself

- Ensure your project has Pages enabled if you want hosted documentation

## 📦 Output Location

Generated documentation is moved to:

```ascii
public/
```

This directory is used by GitLab Pages for publication.
