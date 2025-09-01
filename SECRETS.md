# Secrets Management with SOPS and Age

This project uses [SOPS](https://github.com/getsops/sops) with [Age](https://github.com/FiloSottile/age) encryption for managing secrets.

## Initial Setup

### 1. Install Tools

```bash
mise use -g sops@latest age@latest
```

### 2. Generate Age Keypair

```bash
age-keygen -o ~/.config/mise/age.txt
# Note the public key output for encryption
```

### 3. Configure Mise

Mise automatically uses the age key from `~/.config/mise/age.txt` or you can set it:

```bash
mise settings set sops.age_key_file ~/.config/mise/age.txt
```

## Managing Secrets

### Creating Secrets

1. Copy the example file:
```bash
cp .env.example.yaml .env.yaml
```

2. Edit with your actual values:
```bash
nano .env.yaml
```

3. Encrypt the file:
```bash
sops encrypt -i --age "YOUR_AGE_PUBLIC_KEY" .env.yaml
```

### Editing Secrets

```bash
export SOPS_AGE_KEY_FILE=~/.config/mise/age.txt
sops edit .env.yaml
```

### Using Secrets

Mise automatically decrypts the `.env.yaml` file when running commands:

```bash
mise run deploy  # Secrets are available as env vars
```

## CI/CD Setup

For GitHub Actions:

1. Export your age private key:
```bash
cat ~/.config/mise/age.txt | base64
```

2. Add as GitHub Secret: `AGE_PRIVATE_KEY`

3. In your workflow:
```yaml
- name: Setup Age Key
  run: |
    echo "${{ secrets.AGE_PRIVATE_KEY }}" | base64 -d > /tmp/age.txt
    export SOPS_AGE_KEY_FILE=/tmp/age.txt
```

## Security Notes

- **NEVER** commit unencrypted `.env.yaml` files
- **NEVER** commit age private keys
- The encrypted `.env.yaml` file is safe to commit
- Use different age keys for different environments (dev/staging/prod)