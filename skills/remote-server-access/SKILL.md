---
name: remote-server-access
description: Connect to and operate remote servers using local SSH configuration or platform credential stores, guided by the repository's .context/infrastructure.md. Use when a task requires inspecting, troubleshooting, changing, or deploying to a remote host.
---

# Remote Server Access

Use this skill whenever work requires a remote server. Read the repository's
`.context/infrastructure.md` before connecting; it is the source of truth for
host aliases, users, ports, authentication references, capabilities, and
server-specific procedures.

## Credential boundaries

- Never ask the user to paste a private key, password, token, or `.env` value
  into chat.
- Never print credentials, private keys, credential-command output, or secret
  files.
- Prefer SSH keys and the platform's SSH agent.
- For password-based access, use the local platform store only:
  - Windows: Windows Credential Manager;
  - macOS: Keychain;
  - Linux: Secret Service or `pass`.
- Treat paths, variable names, and secret references in
  `.context/infrastructure.md` as pointers, not as permission to reveal values.

## Connection workflow

1. Read `.context/infrastructure.md` and select the matching host entry.
2. Check the required local tools (`ssh`, `scp`, `sftp`, or the documented
   credential helper) without exposing secrets.
3. Prefer the documented SSH alias, for example `ssh prod-api`, so host keys,
   user, port, and key selection come from local configuration.
4. If the entry specifies a credential reference, invoke its local helper only
   at the moment it is needed. Keep the value in memory and never write it to
   a repository file or command log.
5. Start with a read-only identity and health check such as `whoami`, hostname,
   service status, disk, memory, or relevant logs.
6. Perform the requested work using the server's documented procedures.
7. Verify the resulting state and report the host, commands or operations
   performed, and verification result without including secrets.

## Platform patterns

### Windows

- SSH keys normally live under `%USERPROFILE%\\.ssh`.
- Use Windows OpenSSH `ssh-agent` and `ssh-add` for passphrase-protected keys.
- Use Windows Credential Manager for password-only hosts through a local helper;
  do not put passwords in `.env`, command arguments, or Markdown.

### macOS

- SSH keys normally live under `~/.ssh`.
- Use `ssh-agent` and macOS Keychain for passphrase-protected keys.
- Use `security` or a local helper to retrieve password credentials only when
  the infrastructure entry explicitly names the credential reference.

### Linux

- SSH keys normally live under `~/.ssh`.
- Use `ssh-agent`, Secret Service, or `pass` according to the local setup.
- Never assume a secret store or helper exists; check the documented provider.

## Safety and scope

The user may authorize the agent to do whatever the task requires on a listed
server, but the agent must still stay within the task and the server entry.
Do not improvise access to hosts that are not documented. Before destructive,
irreversible, security-sensitive, or production-wide changes, state the exact
operation and target and obtain confirmation unless the user has already
authorized that specific operation in the current request.

When a connection fails, diagnose locally first: alias resolution, DNS, port,
host-key mismatch, agent state, and credential-provider availability. Do not
weaken host-key verification or bypass security controls to make a connection
work.
