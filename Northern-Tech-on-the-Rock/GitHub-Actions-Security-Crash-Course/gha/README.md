# Workshop: GitHub Actions Crash Course

This module focuses on setting up a secure CI/CD pipeline using GitHub Actions, Cloudflare Pages, and OWASP ZAP for automated security testing.

## Project Overview

The goal of this workshop is to demonstrate how to deploy a static web application and automatically perform a Dynamic Application Security Testing (DAST) scan to identify vulnerabilities using the OWASP ZAP Baseline Scan.

### Key Components

-   **Web Application**: A lightweight static site located in `gha/web/`.
    -   `index.html`: The main landing page containing a sample form.
    -   `style.css`: Basic styling.
-   **CI/CD Pipeline**: `.github/workflows/security-scan.yml` orchestrates deployment and scanning.
-   **Security Configuration**: ZAP scan rules are customized in `.zap/rules.tsv` to reduce noise by ignoring specific alerts (e.g., missing CSP headers).

## Workflow Architecture

The pipeline (`security-scan.yml`) is designed to support both manual test deployments and automated verification of existing deployments.

### Triggers
1.  **`workflow_dispatch` (Manual)**: Allows you to manually trigger a deployment to the `TEST` environment and scan it. You can optionally specify a `target_url` to scan an existing site instead of deploying a new one.
2.  **`deployment_status` (Automated)**: Triggered when a deployment event occurs (e.g., from an external Cloudflare integration). The workflow listens for "success" status and scans the provided deployment URL.

### Jobs

1.  **`deploy` (Deploy to Cloudflare Pages)**:
    -   *Condition*: Runs only on manual trigger (`workflow_dispatch`).
    -   *Action*: Uses `cloudflare/wrangler-action` to deploy the `./gha/web` directory.
    -   *Environment*: Targets the `TEST` environment.
    -   *Output*: Exports the resulting live URL.

2.  **`zap_scan` (Scan the Website)**:
    -   *Condition*: Runs if deployment succeeds OR if triggered by `deployment_status`.
    -   *Action*: Executes the `zaproxy/action-baseline` scan.
    -   *Logic*: Automatically determines the target URL (newly deployed URL, custom input URL, or external deployment URL).
    -   *Artifacts*: Generates a `zap_scan` artifact containing the HTML security report.

## Getting Started

### 1. Prerequisites (Secrets)
Configure the following secrets in your GitHub Repository (**Settings > Secrets and variables > Actions**):

| Secret Name             | Description                                                            |
| :---------------------- | :--------------------------------------------------------------------- |
| `CF_API_TOKEN`          | Your Cloudflare API token with Pages edit permissions.                 |
| `CF_ACCOUNT_ID`         | Your Cloudflare Account ID.                                            |
| `CF_PAGES_PROJECT_NAME` | The name of your Cloudflare Pages project (e.g., `gha-workshop-demo`). |

### 2. Running the Pipeline
1.  Navigate to the **Actions** tab in your GitHub repository.
2.  Select the **Security Scan** workflow.
3.  Click **Run workflow**.
    *   Leave `target_url` as default to deploy and scan the `gha/web` folder.
    *   Or, enter a specific URL to scan that target directly without deploying.

### 3. Verification
*   **Monitor**: Watch the workflow steps execute.
*   **Report**: After completion, download the **zap_scan** artifact to view the detailed HTML security report.
