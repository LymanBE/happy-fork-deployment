# Required GitHub Secrets

To enable CI/CD, you need to configure the following secrets in your GitHub repository settings:

## Required Secrets

### 1. AGE_PRIVATE_KEY (Required)
Base64-encoded age private key for decrypting secrets:
```bash
cat ~/.config/mise/age.txt | base64 -w0
```
Add this value to GitHub Secrets.

### 2. DOKPLOY_SSH_KEY (Required for deployment)
SSH private key for accessing the Dokploy server:
```bash
cat ~/.ssh/id_rsa | base64 -w0
```
Or generate a deploy key specifically for GitHub Actions.

### 3. DOKPLOY_API_KEY (Optional)
API key from Dokploy dashboard (if using API deployment).
Get from Dokploy UI at http://100.119.254.98:3000/settings/profile

### 4. GITHUB_TOKEN (Automatic)
Automatically provided by GitHub Actions for releases.

## Setting Secrets

1. Go to https://github.com/LymanBE/happy-fork-deployment/settings/secrets/actions
2. Click "New repository secret"
3. Add each secret with the appropriate name and value

## Environments

Create a "production" environment:
1. Go to Settings → Environments
2. Create "production" environment
3. Add protection rules if needed