
````markdown
# GPG Key Export & Import

This README describes how to export your GPG public and secret keys to files on a local Linux PC, and how to import them back into GPG. Use these steps to back up your keys or transfer them to another machine.

---

## Prerequisites

- GPG installed (`gpg --version`)  
- You know your key’s identifier (key ID) or the email address associated with the key.

---

## 1. Export Keys

### 1.1 Export Your Public Key

```bash
# ASCII-armored (text) format — suitable for sharing/printing
gpg --armor --output public-key.asc --export <KEY_ID_OR_EMAIL>

# Binary format
gpg --output public-key.gpg --export <KEY_ID_OR_EMAIL>
````

* Replace `<KEY_ID_OR_EMAIL>` with your key ID (e.g. `0x1234ABCD`) or the email address on the key.
* Output files:

  * `public-key.asc` — ASCII-armored (human-readable)
  * `public-key.gpg` — binary

---

### 1.2 Export Your Secret (Private) Key

> **⚠️ Security Warning:** Keep your secret key file safe! Only export it to a secure location and transfer it over encrypted channels (e.g. SCP/SSH).

```bash
# ASCII-armored (text) format
gpg --armor --output private-key.asc --export-secret-keys <KEY_ID_OR_EMAIL>

# Binary format
gpg --output private-key.gpg --export-secret-keys <KEY_ID_OR_EMAIL>
```

* Output files:

  * `private-key.asc` — ASCII-armored
  * `private-key.gpg` — binary

---

## 2. Import Keys

### 2.1 Import a Public Key

```bash
# From ASCII-armored or binary file
gpg --import public-key.asc
# or
gpg --import public-key.gpg
```

* Verify with:

  ```bash
  gpg --list-keys
  ```

---

### 2.2 Import a Secret (Private) Key

```bash
# From ASCII-armored or binary file
gpg --import private-key.asc
# or
gpg --import private-key.gpg
```

* Verify with:

  ```bash
  gpg --list-secret-keys
  ```

---

## 3. Verify & Manage

```bash
# List all public keys
gpg --list-keys

# List all secret keys
gpg --list-secret-keys

# Edit key settings (e.g. trust level, passphrase)
gpg --edit-key <KEY_ID>
```

Your keys should now be correctly exported, imported, and available for use. Enjoy secure signing and encryption!

```
```
