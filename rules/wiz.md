# Wiz Access

Use the official `wiz` MCP server first for Wiz issues, findings,
vulnerabilities, affected resources, evidence, attack paths, ownership, and
remediation guidance. Keep Gateway mode enabled unless the task specifically
requires direct access to the full tool catalog.

If Wiz MCP is unavailable, returns incomplete data, lacks the required tool, or
cannot expose a finding because of permissions, use the installed Wiz extension
in the user's existing VS Code session as the fallback. Inspect its visible
finding details, affected files, evidence, and remediation guidance before
falling back to the Wiz browser portal. Do not install, reconfigure, or
reauthorize the extension unless the user asks.

Treat Wiz access as read-only by default. Preview the exact operation and obtain
explicit user confirmation before changing issue state, adding notes, creating
exceptions, suppressing findings, changing policies, or performing any other
remote write.
