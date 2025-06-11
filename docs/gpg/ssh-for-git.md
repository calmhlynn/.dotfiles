# GitHub SSH Setup with GPG Keys Guide

This guide shows how to set up GitHub SSH authentication using GPG keys. This approach allows you to use a single GPG key for both Git commit signing and SSH authentication.

## Prerequisites

- GPG key must already be generated
- GitHub account required

## Setup Process

### 1. Check Existing GPG Keys

First, check the list of currently generated GPG keys.

```bash
gpg --list-secret-keys --keyid-format LONG
```

**Example output:**
```
/home/user/.gnupg/pubring.kbx
-------------------------------
sec   ed25519/E201D1FA43538FCC 2025-05-27 [SC]
      913FBD0B6CDFCAFE8FB80C8FE201D1FA43538FCC
uid                 [ultimate] calmhlynn <barca105@naver.com>
ssb   cv25519/F57E126F375DC495 2025-05-27 [E]
```

> **Important:** The `E201D1FA43538FCC` part is the key ID. Remember this for the next step.

### 2. Generate Authentication Subkey

Create a subkey for SSH authentication.

```bash
gpg --expert --edit-key E201D1FA43538FCC
```

In GPG edit mode, enter the following commands in order:

1. **Add new key:** Enter `addkey`
2. **Select key type:** Enter `11` (ECC with custom capabilities)
3. **Enable authentication only:**
   - Enter `S` (disable Sign capability)
   - Enter `A` (enable Authenticate capability)
   - Enter `Q` (finish)
4. **Select curve:** Enter `1` (Curve 25519 - recommended)
5. **Set expiration:** Enter `0` (no expiration) or set desired period
6. **Save:** Enter `save`

### 3. Verify Subkey Creation

Verify that the subkey was created properly.

```bash
gpg --list-secret-keys --keyid-format LONG
```

**Example output:**
```
/home/skjung/.gnupg/pubring.kbx
-------------------------------
sec   ed25519/E201D1FA43538FCC 2025-05-27 [SC]
      913FBD0B6CDFCAFE8FB80C8FE201D1FA43538FCC
uid                 [ultimate] calmhlynn <barca105@naver.com>
ssb   cv25519/F57E126F375DC495 2025-05-27 [E]
ssb   ed25519/9EB0F189248491DA 2025-06-10 [A]  ← Newly created authentication subkey
```

> Success if you see a subkey with `[A]` designation.

### 4. Enable GPG Agent SSH Support

Configure GPG Agent to act as SSH agent.

**Create/edit file:** `~/.gnupg/gpg-agent.conf`
```
enable-ssh-support
```

**Restart GPG Agent:**
```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

### 5. Export SSH Public Key

Extract the SSH public key from GPG.

```bash
ssh-add -L
```

> Copy the output public key. You'll need it to register on GitHub.

### 6. Register SSH Key on GitHub

You need to add the same SSH key twice with different key types for full functionality.

**First Registration (Authentication Key):**
1. **Access GitHub:** [github.com](https://github.com) → Settings
2. **SSH Key Settings:** Left sidebar → "SSH and GPG keys"
3. **Add New Key:** Click "New SSH key" button
4. **Enter Key Information:**
   - **Title:** Key name (e.g., "GPG SSH Key - Auth")
   - **Key type:** Select "Authentication Key"
   - **Key:** Paste the public key copied from step 5
5. **Save:** Click "Add SSH key" button

**Second Registration (Signing Key):**
6. **Add Another Key:** Click "New SSH key" button again
7. **Enter Key Information:**
   - **Title:** Key name (e.g., "GPG SSH Key - Sign")
   - **Key type:** Select "Signing Key"
   - **Key:** Paste the same public key from step 5
8. **Save:** Click "Add SSH key" button

> **Important:** You must add the same SSH public key twice - once as "Authentication Key" for SSH connections and once as "Signing Key" for commit verification. This allows GitHub to use your GPG key for both authentication and signing purposes.

### 7. Configure Git Signing Key

Configure Git to use your GPG key for commit signing.

```bash
# Use your GPG key ID from step 1
git config --global user.signingkey E201D1FA43538FCC
```

**Or add to your `.gitconfig` file:**
```ini
[user]
    name = Your Name
    email = your.email@example.com
    signingkey = E201D1FA43538FCC
```

> Replace `E201D1FA43538FCC` with your actual GPG key ID from step 1.

### 8. Configure SSH Config File

Configure SSH to use GPG Agent.

**Create/edit file:** `~/.ssh/config`
```
Host github.com
  HostName github.com
  User git
  IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
```

> The `/run/user/1000` part may vary depending on your user ID. Check with `echo $UID`.

### 9. Test Connection

Test if the setup is working correctly.

```bash
ssh -T git@github.com
```

**Success output:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

## Complete

You've now set up GitHub SSH authentication using GPG keys. You can manage both Git commit signing and SSH authentication with a single key.

## Troubleshooting

### If GPG Agent doesn't start
```bash
# Check GPG Agent process
ps aux | grep gpg-agent

# Manually start GPG Agent
gpg-agent --daemon --enable-ssh-support
```

### If SSH key is not recognized
```bash
# Check environment variable settings
echo $SSH_AUTH_SOCK

# Check GPG Agent SSH socket path
gpgconf --list-dirs agent-ssh-socket
