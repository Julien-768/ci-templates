# sync-github

Reusable GitLab CI/CD component that mirrors selected branches to a GitHub
repository on every push.

---

## Inputs

| Name          | Description                                   | Default        |
| ------------- | --------------------------------------------- | -------------- |
| `branches`    | Comma-separated list of branches to sync      | `develop,main` |
| `github_repo` | Target GitHub repository, format `owner/repo` | _(required)_   |
| `stage`       | CI stage used for the job                     | `deploy`       |

---

## Required variables

- `CI_PUSH_TOKEN`: GitHub personal access token with `repo` scope, set as a
  **masked** and **protected** CI/CD variable
  (`Settings > CI/CD > Variables`).

---

## Example usage

```yaml
include:
  - component: gitlab.in2p3.fr/rfid.m0/rfid/sync-github@develop
    inputs:
      branches: "develop,main"
      github_repo: "your-user/your-repo"
```

---

## Notes

- The job only runs when the branch being pushed matches one of the entries
  in `branches`.
- The pipeline running this component must define a stage matching `stage`
  (default `deploy`) in its `stages:` list.
- The GitHub push uses `--force`-free mirroring by default; if GitHub is meant
  to be a strict mirror and history divergence is expected, add `--force` to
  the push command in `templates/sync-github/template.yml`.
