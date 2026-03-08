# Contributing to Axiom

Thank you for your interest in contributing to Axiom! Here's how to help.

## How to Contribute

### Reporting Issues

- Use [GitHub Issues](https://github.com/ecomxco/axiom/issues)
- Include which workflow, what happened, and what you expected

### Suggesting Workflows

- Open an issue with the `enhancement` label
- Describe the problem the workflow would solve
- Include a rough outline of the steps

### Improving Existing Workflows

1. Fork the repo
2. Create a feature branch (`git checkout -b improve-verify-work`)
3. Make your changes
4. Test with at least one AI agent
5. Submit a pull request

## Workflow Standards

Every workflow must:

- Have YAML frontmatter with a `description` field
- Start with a `# Title` and a one-line summary
- Include a `## When to Use` section
- Have numbered steps with clear inputs and outputs
- End with a `## ▶ Next` routing section
- Use `// turbo` annotations for safe-to-autorun commands

## Code of Conduct

Be respectful, constructive, and specific. We're building tools for serious operators — quality matters more than quantity.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
