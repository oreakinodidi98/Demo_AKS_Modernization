# GitHub Copilot App Modernization CLI

Batch assessments across multiple repositories to generate insights, modernization opportunities, and deployment recommendations for Azure services.

## Overview

- Simultaneously assess applications across multiple repos and different languages, either locally or by delegating to a cloud coding agent
- Recommend migration waves based on identified issues and level of effort
- Generate actionable modernization plans and upgrade paths

## When to Use

### CLI

| | Details |
|---|---|
| **Purpose** | Batch assessments, custom modernization plans, and upgrades |
| **Customer Audience** | Application owners and architects |
| **Field Audience** | Solution Engineers |

### IDE (VS Code Extension)

| | Details |
|---|---|
| **Purpose** | Single application assessment, custom modernization plan, upgrade, and deployment |
| **Customer Audience** | Developers |
| **Field Audience** | Cloud Solution Architects |

## Getting Started

### Prerequisites

- [GitHub CLI](https://cli.github.com/) installed
- Authenticated GitHub account

### Authentication

```bash
# Log in to GitHub
gh auth login

# Verify authentication status
gh auth status
```

### Usage

```bash
# Run the modernization agent
modernize
```

### Single Repository

The `modernize` command provides three options for a single project:

1. **Assess Application** — Analyze the application for modernization readiness
2. **Generate Modernization Plan** — Outputs a `plan.md` master file containing:
   - All scenarios similar to the IDE experience in VS Code
   - Designed for Copilot to execute in one-shot
3. **Execute Modernization Plan** — Run the generated plan:
   1. Select the target directory
   2. Select a plan (supports multiple modernization plans)
   3. Execute the plan (optionally provide additional context via prompt, or press Enter to proceed)

### Multi-Repository

Assess multiple repositories in a single batch run.

**Setup:**

1. Navigate to the `.github/modernize/` folder in your repo
2. Create a `repos.json` file listing the repositories to assess:

```json
[
  {
    "name": "Containerization_Assist_App_Mod",
    "url": "https://github.com/oreakinodidi98/Containerization_Assist_App_Mod"
  }
]
```

**Running Multi-Repo Assessments:**

You can source repositories either locally or from GitHub:

- **Local source** — Place all project directories under a parent folder and run:

  ```bash
  modernize -source c:/repos
  ```

- **GitHub source** — Run `modernize` to scan and identify all repositories listed in `repos.json`

Then select the projects to assess (`Ctrl+A` to select all) and choose an assessment mode:

| Mode | Description |
|---|---|
| **Assess Locally** | Clones all listed repos from GitHub, iterates through each source code project, and produces a consolidated assessment report |
| **Delegate to Cloud Coding Agents** | Offloads assessment to [cloud coding agents](https://code.visualstudio.com/docs/copilot/agents/cloud-agents) for parallel processing |