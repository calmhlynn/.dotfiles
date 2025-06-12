# The Ultimate Guide to Using Your GPG Key for Both GitHub SSH Authentication and Commit Signing

This guide shows you how to use a single GPG key for both SSH authentication to GitHub and for signing Git commits.

## Prerequisites

- You already have a GPG key pair created.  
- You have a GitHub account.

## Steps

### 1. Check Your Existing GPG Keys

List your secret keys and their long-format IDs:

```bash
gpg --list-secret-keys --keyid-format LONG
```

**Example output:**

```
/home/user/.gnupg/pubring.kbx
-------------------------------
sec   ed25519/1A2B3C4D5E6F7G8H 2025-05-27 [SC]
      9ABCDEF0123456789ABCDEF0123456789ABCDEF
uid                      [ultimate] user@example.com
ssb   cv25519/9F8E7D6C5B4A3210 2025-05-27 [E]
```

> **Note:** `1A2B3C4D5E6F7G8H` is your master key’s ID.

### 2. Create an Authentication Subkey

For SSH, you **must** have a subkey with the Authenticate (`A`) capability. You can also create a dual-purpose Sign+Authenticate (`SA`) subkey.

```bash
gpg --expert --edit-key 1A2B3C4D5E6F7G8H
```

In the GPG prompt:

1. `addkey`  
2. Choose key type (e.g. `11` for ECC custom, or `8` for RSA custom)  
3. When prompted for capabilities:  
   - **Authenticate-only `[A]`**: Press `S` to disable signing, press `A` to enable authentication  
   - **Sign+Authenticate `[SA]`**: Enable both signing and authentication  
   - Press `Q` to finish  
4. If ECC, choose `1` for Curve 25519  
5. Set expiry (`0` for no expiry, or e.g. `1y`)  
6. `save` to exit

### 3. Register Your Subkey’s Keygrip in `sshcontrol`

1. Find the keygrip:

   ```bash
   gpg --list-keys --with-keygrip
   ```

   **Example:**

   ```
   ssb   ed25519 2025-06-10 [A]
         Keygrip = 1234567890ABCDEF1234567890ABCDEF12345678
   ```

2. Add it to `~/.gnupg/sshcontrol`:

   ```bash
   echo "1234567890ABCDEF1234567890ABCDEF12345678" >> ~/.gnupg/sshcontrol
   ```

### 4. Enable SSH Support and Reload gpg-agent

Add to `~/.gnupg/gpg-agent.conf`:

```
enable-ssh-support
```

Then reload:

```bash
gpg-connect-agent reloadagent /bye
```

### 5. Export Your SSH-Format Public Key

```bash
gpg --export-ssh-key 1A2B3C4D5E6F7G8H!
```

Copy the output (e.g. `ssh-ed25519 AAAA... user@example.com`). Verify with:

```bash
ssh-add -L
```

### 6. Add the Key to GitHub (Twice)

1. **Authentication Key**  
   - GitHub → Settings → SSH and GPG keys → New SSH key  
   - Title: “GPG SSH Key – Auth”  
   - Type: Authentication key  
   - Paste your public key → Add SSH key

2. **Signing Key**  
   - Settings → SSH and GPG keys → New SSH key  
   - Title: “GPG SSH Key – Sign”  
   - Type: Signing key  
   - Paste the same public key → Add SSH key

### 7. Configure Git to Sign All Commits

```bash
git config --global user.signingkey 1A2B3C4D5E6F7G8H
git config --global commit.gpgsign true
```

### 8. Point SSH to Your gpg-agent Socket

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
```

Reload with:

```bash
source ~/.bashrc
```

_Optional_: In `~/.ssh/config`:

```
Host github.com
  HostName github.com
  User git
  # IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
```

### 9. Test the Setup

```bash
ssh -T git@github.com
```

Expected:

```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```
