# Agent modules

`modules/agents/` contains Home Manager integrations for AI coding agents and agent-oriented development tools. These modules are separate from ordinary applications because they configure an agent workflow and may also declare persistence for agent state.

## Available modules

| Module ID | Implementation | Responsibility |
| --- | --- | --- |
| `agents.antigravity` | `antigravity.nix` | Enables the Antigravity CLI integration and keeps its settings mutable. |
| `agents.codex` | `codex.nix` | Enables the Home Manager Codex program; mutable settings are enabled on non-Darwin systems. |

## Persistence

The NixOS preservation aspect in these files conditionally keeps each agent's user data when its corresponding Home Manager program is enabled:

- Antigravity: `.antigravity-ide`
- Codex: `.codex`

The persistence declarations are separate from the Home Manager program modules. They do not enable either agent by themselves.

## Boundaries

- Put agent-specific installation and settings here.
- Put shared language runtimes and development toolchains in `modules/development/`.
- Put ordinary applications and command-line utilities in `modules/programs/`.
- Keep credentials and API tokens in the repository's encrypted secret-management flow; do not put plaintext secrets in module files.

Add future agent integrations here when they own a distinct agent workflow or state directory.
