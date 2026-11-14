# Program modules

This directory contains user-facing applications and tools. Source paths organize
implementation files; the public Dendritic module identifiers are defined by
each file's `flake.modules.*` declarations.

## Layout

- `cli/`: command-line tools and utilities that do not have a more specific functional domain.
- `git.nix`: shared Git configuration, exposed as `programs.git`; CLI roles may import it without making Git CLI-only in the module taxonomy.
- `system/`: shared per-user system clients and baseline configuration, such
  as the SSH client.
- `desktop/`: graphical applications grouped by use case, such as API clients,
  networking, remote access, gaming, communication, media and office.
- `browsers/`: browser applications and browser-specific configuration.
- `editors/`: Neovim, VS Code and GUI editor integration.
- `input-methods/`: input methods and keyboard remapping.
- `media/`: media players and their scripts.
- `shells/`: shell configuration.
- `terminals/`: terminal emulators and multiplexers.

AI Agent integrations live in `modules/agents/`. Development language runtimes and toolchains live in `modules/development/`;
security-related configuration lives in `modules/security/`.

## Module boundaries

- Home Manager modules own per-user application settings and packages.
- NixOS and nix-darwin modules own system services, system packages,
  persistence declarations and Homebrew casks.
- Platform-specific behavior belongs in the corresponding
  `homeManager.linux`, `homeManager.darwin`, `nixos` or `darwin` module.
- Reusable program modules are imported by their owning host or role; keep
  optional desktop applications out of the headless CLI/server composition.
- Keep files that are loaded through relative paths (for example
  `tridactylrc` and `p10k.zsh`) alongside their owning module.

## Nested program modules

A program's reusable configuration should be owned by that program rather than
by a broad desktop profile. For example, `programs.mpv` imports its own
ModernZ options, playback-state script and locale resources; desktop program
groups only select applications as part of the host's application set.
