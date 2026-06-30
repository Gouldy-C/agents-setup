# Runbook

## Prerequisites

[Required tools, versions, environment variables, access.]

## Local development

```bash
# Install dependencies
[command]

# Start dev server / process
[command]
```

## Testing

```bash
# Run all tests
[command]

# Run unit tests only (if separate)
[command]

# Run a single test or subset
[command with framework-specific filter flag]

# Coverage (if used in CI)
[command]
```

[Test file locations and naming conventions.
Whether CI requires full suite green before merge.
Add or update tests for code you change.]

## Linting and formatting

```bash
[command - must match what CI runs]
```

## Pull request checks

Before opening a PR, run:

```bash
[lint command]
[test command]
```

[PR title format, e.g. `[component] Brief description`.
Required reviewers or checks if applicable.]

## Building

```bash
[command]
```

## Deploying

[How releases reach production or staging.
Link to CI/CD if applicable.]

## Debugging

[Common failure modes and how to diagnose them.
Log locations.
Useful flags.]
