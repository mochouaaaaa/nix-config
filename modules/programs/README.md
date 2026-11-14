# Program modules

This directory is organized by the responsibility of each program module. The
Dendritic module identifiers remain independent from source paths: moving a
file does not change its `flake.modules.*` interface or the host composition.

## Layout

- `browsers/`: browser applications and browser-specific configuration.
- `cli/`: command-line tools and shell utilities.
- `development/`: developer tools, Git, SSH, database and API clients.
- `desktop/`: desktop applications grouped by use case, such as networking,
  remote access, gaming, communication, media and office.
- `editors/`: Neovim, VS Code and GUI editor integration.
- `input-methods/`: input methods and keyboard remapping.
- `media/`: media players and their scripts.
- `shells/`: shell configuration.
- `terminals/`: terminal emulators and multiplexers.

System integration belongs to the module class that owns the setting:
Home Manager for per-user packages and configuration, NixOS for system
packages and permissions, and nix-darwin for Homebrew casks. Keep those
integrations alongside the application they serve rather than collecting
unrelated applications in a generic `system/` directory. Desktop infrastructure
that is not an individual application, such as Flatpak, belongs in
`modules/desktop/`.

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
