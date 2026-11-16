# Program modules

`modules/programs/` contains reusable user-facing applications and tools. The source tree groups implementation files by function; public Dendritic module IDs are declared by each file's `flake.modules.*` attributes and do not have to mirror the source path exactly.

## Layout

| Directory / file | Responsibility |
| --- | --- |
| `browsers/` | Chromium and Firefox, including platform-specific configuration, profiles, plugins and Tridactyl integration. |
| `cli/` | Command-line tools and utilities without a more specific functional domain, such as bat, btop, direnv, eza, fd, fzf, jq, lazygit, nh, ripgrep, television, yazi and zoxide. |
| `desktop/` | Graphical applications grouped by use case: audio, authentication, communication, email, gaming, networking, notes, remote access and office. |
| `editors/` | Neovim, VS Code and Neovide, including editor plugins, language tooling and platform-specific setup. |
| `input-methods/` | Rime and xremap configuration with platform-specific integration. |
| `media/` | Media players and their supporting scripts; mpv configuration and scripts are kept alongside the mpv module. |
| `shells/` | Shell configuration, currently Zsh aliases, settings, plugins and proxy helpers. |
| `system/` | Per-user system clients and baseline configuration, such as the SSH client. |
| `terminals/` | Terminal emulators and multiplexers, including Kitty and tmux. |
| `git.nix` | Shared Git and GitHub CLI configuration, exposed as `programs.git`. |

## Module boundaries

- Home Manager modules own per-user application packages and settings.
- NixOS and nix-darwin modules own system services, system packages, persistence declarations and Homebrew casks when a program needs system-level integration.
- Platform-specific behavior belongs in the corresponding `homeManager`, `nixos` or `darwin` module rather than being forced into a cross-platform definition.
- Reusable program modules are imported by their owning Host or role. Keep optional desktop applications out of headless CLI/server compositions.
- Keep files loaded through relative paths (for example `tridactylrc` and `p10k.zsh`) alongside the module that consumes them.

## Desktop application groups

The `modules/programs/desktop/profiles.nix` module registers the compatibility aggregate `desktop.programs`. It imports the individual `desktop.programs.*` groups for API clients, browsers, audio, security, communication, email, media, notes, remote access, office and networking.

Hosts that need a smaller application set should import individual groups instead of the aggregate. Database clients are maintained separately in `modules/desktop/programs/db-clients.nix` as `desktop.programs.database`; API clients are also implemented under `modules/desktop/programs/`.

The desktop session itself is configured under `modules/desktop/`, not here. See [../desktop/README.md](../desktop/README.md) for compositor and desktop composition details.

## Nested program modules

A program's reusable configuration should be owned by that program rather than by a broad desktop profile. For example, `programs.mpv` owns its ModernZ options, playback-state script and locale resources; desktop application groups only select which applications are included in a Host's user environment.

AI Agent integrations live in [../agents/](../agents/README.md). Development language runtimes and toolchains live in `modules/development/`; security-related configuration lives in `modules/security/`.
