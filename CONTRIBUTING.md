# Contributing to CI Templates

Thank you for considering contributing to our CI templates repository! Here are some guidelines to help you get started.

1. **Fork the Repository**: Start by forking the repository to your own account.
2. **Clone the Repository**: Clone the forked repository to your local machine.
3. **Create a Branch**: Create a new branch for your changes. Use a descriptive name that reflects the nature of your contribution.
4. **Make Changes**: Implement your changes in your local branch.
5. **Test Changes**: Ensure your changes work as expected and pass all relevant tests.
6. **Commit Changes**: Commit your changes with a clear and descriptive message.
7. **Push Changes**: Push your changes to your forked repository.
8. **Create a Merge Request**: Create a merge request from your branch to the repository's `develop` branch.
9. **Review Process**: Your merge request will be reviewed by the repository maintainers. Be prepared to make additional changes if necessary.
10. **Reintegrate Changes**: Once your merge request is approved and merged, update your local repository with the latest changes from the main repository to keep it up-to-date.

## Directory Structure

The repository is organized into component directories, each containing a `template.yml` file and an optional `README.md` file for additional documentation.

```markdown
ci-templates/
├── README.md
├── clang/
│ ├── template.yml
│ └── README.md
├── python/
│ ├── template.yml
│ └── README.md
└── release/
├── template.yml
└── README.md
```

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

## CI Pipeline

The `ci-gitlab.yml` file must include all jobs from the template and must execute successfully for all jobs. This ensures that the CI pipeline is robust and all defined jobs are functioning correctly.

## Design Choices

- **Hidden Template Jobs**: Hidden template jobs (prefixed with a dot) define reusable building blocks.
- **Concrete Jobs**: Concrete jobs (e.g., `clang-format`, `clang-tidy`) are defined in this file so that consuming projects can simply include this template without redefining jobs.
- **Plug-and-Play**: Including this file is sufficient to get the default jobs executed.

## Token Naming Recommendations

When naming tokens for CI/CD pipelines, clarity and consistency are key. Here are some recommendations based on common use cases:

👉 CI_PUSH_TOKEN: Use this if the job needs to push changes to a repository or another system. It clearly indicates the token’s purpose.

👉 CI_ACCESS_TOKEN: Ideal for jobs that call external APIs or services. This name is readable, neutral, and avoids ambiguity.

👉 CI_API_TOKEN: Perfect if the token is exclusively used for API calls. It’s concise and directly describes the token’s role.

Choose names that reflect the token’s purpose to ensure your pipelines remain clean, understandable, and maintainable.

## Commit Messages

Write clear, descriptive commit messages that explain the purpose of your changes. Follow the conventional commit format if applicable.

## Submitting Changes

1. **Push Changes**: Push your changes to your forked repository.
2. **Create a Merge Request**: Create a merge request from your branch to the main repository's `develop` branch.
3. **Review Process**: Your merge request will be reviewed by the repository maintainers. Be prepared to make additional changes if necessary.

## Code Quality

Ensure your changes adhere to the existing code style and pass all CI checks. This includes running clang-format and clang-tidy if applicable.

## Documentation

Update the documentation to reflect any changes you make. This includes updating the headers in the template files and any relevant README files.

## Questions

If you have any questions or need further clarification, feel free to reach out to the repository maintainers.

Happy contributing!
