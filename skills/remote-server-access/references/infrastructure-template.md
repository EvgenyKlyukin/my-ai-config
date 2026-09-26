# Infrastructure Instructions Template

Copy this template to the repository-local `.context/infrastructure.md` and
fill in only non-secret metadata and references. Do not commit the populated
file.

## Access policy

- Default environment: `staging` / `production`
- Unlisted hosts: do not access
- Secret values: never print, copy, or commit
- State-changing operations: follow the task's authorization and verify them

## Host: `<name>`

- Purpose: `<what this host runs>`
- Environment: `<local/staging/production>`
- SSH alias: `<alias from ~/.ssh/config>`
- User: `<user>`
- Port: `<port>`
- Authentication: `ssh-agent` / `credential-store`
- SSH key path: `<path, never the key contents>`
- Credential reference: `<variable or keychain item name>`
- Working directories: `<paths>`
- Services: `<service names>`
- Logs: `<commands or paths>`
- Deploy/restart procedure: `<reference or commands>`
- Backup/rollback procedure: `<reference>`
- Notes: `<server-specific constraints>`
