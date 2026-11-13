# Program modules

This directory is organized by the responsibility of each program module. The
Dendritic module identifiers remain independent from source paths: moving a
file does not change its `flake.modules.*` interface or the host composition.

## Layout

- `browsers/`: browser applications and browser-specific configuration.
- `cli/`: command-line tools and shell utilities.
- `development/`: developer tools, Git, SSH, database and API clients.
- `desktop/`: desktop applications and communication tools.
- `editors/`: Neovim, VS Code and GUI editor integration.
- `input-methods/`: input methods and keyboard remapping.
- `media/`: media players and their scripts.
- `shells/`: shell configuration.
- `system/`: system-level program integration and platform package installation.
- `terminals/`: terminal emulators and multiplexers.

## Module boundaries

- Home Manager modules own per-user application settings and packages.
- NixOS and nix-darwin modules own system services, system packages,
  persistence declarations and Homebrew casks.
- Platform-specific behavior belongs in the corresponding
  `homeManager.linux`, `homeManager.darwin`, `nixos` or `darwin` module.
- Reusable program modules are imported by their owning host or desktop
  composition; avoid making every desktop application part of
  `desktop.common` by default.
- Keep files that are loaded through relative paths (for example
  `tridactylrc` and `p10k.zsh`) alongside their owning module.

## Nested program modules

A program's reusable configuration should be owned by that program rather than by a broad desktop profile. For example, `programs.mpv` imports its own ModernZ options, playback-state script and locale resources; `desktop.programs.media` only selects MPV as part of the host's media application set.
