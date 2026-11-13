# Mochou Nix configuration tasks
# Usage:
#   just                 Show available recipes
#   just check           Evaluate flake outputs without building derivations
#   just nixos-switch    Switch the configured NixOS host
#   just darwin-switch   Switch the configured Darwin host
#
# Override defaults when needed:
#   NH_FLAKE=/path/to/nix just check
#   NH_HOST=mochou@nixos just nixos-switch
#   NH_DARWIN_HOST=mochou@darwin just darwin-switch

set shell := ["bash", "-cu"]

# The repository containing this justfile.
FLAKE := env_var_or_default("NH_FLAKE", justfile_directory())

# Host directory names under hosts/<username>@<hostname>/.
# NH_HOST is used by NixOS recipes; Darwin has its own independent default.
HOST := env_var_or_default("NH_HOST", "mochou@nixos")
DARWIN_HOST := env_var_or_default("NH_DARWIN_HOST", "mochou@darwin")

# These are only needed by configurations that intentionally allow
# unfree/insecure packages. They are passed to Nix commands with --impure.
NIX_ALLOW := "NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1"

# Default recipe.
default:
    @just --list

# ---------------------------------------------------------------------------
# Repository / flake
# ---------------------------------------------------------------------------

[group('flake')]
show:
    {{NIX_ALLOW}} nix flake show "{{FLAKE}}" --impure

[group('flake')]
lock:
    nix flake lock "{{FLAKE}}"

[group('flake')]
update:
    nix flake update "{{FLAKE}}"

[group('flake')]
[linux]
update-linux:
    nix flake update "{{FLAKE}}" nixpkgs nixpkgs-stable home-manager nixos-wsl disko

[group('flake')]
[macos]
update-darwin:
    nix flake update "{{FLAKE}}" nixpkgs-darwin nix-darwin home-manager-darwin

[group('flake')]
update-desktop:
    nix flake update "{{FLAKE}}" plasma-manager

[group('flake')]
hosts:
    @find "{{FLAKE}}/hosts" -mindepth 1 -maxdepth 1 -type d -print | sort

[group('flake')]
host-config:
    @sed -n '1,220p' "{{FLAKE}}/hosts/{{HOST}}/default.nix"

# ---------------------------------------------------------------------------
# Quality checks
# ---------------------------------------------------------------------------

[group('quality')]
fmt:
    nix fmt "{{FLAKE}}"

[group('quality')]
fmt-check:
    find "{{FLAKE}}" -path "{{FLAKE}}/.git" -prune -o -path "{{FLAKE}}/.direnv" -prune -o -name '*.nix' -print0 | xargs -0 -r nixfmt --check

[group('quality')]
lint:
    cd "{{FLAKE}}" && statix check .
    cd "{{FLAKE}}" && deadnix --fail .

[group('quality')]
check:
    NIX_CONFIG_CHECK=1 {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --no-build --impure --show-trace --all-systems

[group('quality')]
check-build:
    {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --impure --show-trace

[group('quality')]
validate: fmt-check lint check

# Evaluate the current platform's configured host without building its system closure.
[group('quality')]
[linux]
validate-hosts: nixos-eval

[group('quality')]
[macos]
validate-hosts: darwin-eval

# ---------------------------------------------------------------------------
# NixOS
# ---------------------------------------------------------------------------

[group('nixos')]
[linux]
nixos-eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('nixos')]
[linux]
nixos-build:
    {{NIX_ALLOW}} nh os build "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
[linux]
nixos-boot:
    {{NIX_ALLOW}} nh os boot "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
[linux]
nixos-switch:
    {{NIX_ALLOW}} nh os switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
[linux]
nixos-test:
    {{NIX_ALLOW}} nh os test "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
[linux]
nixos-repl:
    {{NIX_ALLOW}} nixos-rebuild repl --flake "{{FLAKE}}#{{HOST}}" --impure

# List available NixOS desktop entry modules and mark the host's selected desktop.
[group('nixos')]
[linux]
desktop:
    @nix eval --raw --apply 'modules: builtins.concatStringsSep "\n" (builtins.filter (name: builtins.match "desktop\\.(hyprland|niri|gnome|kde)$" name != null) (builtins.attrNames modules))' "{{FLAKE}}#modules.nixos" | while IFS= read -r module; do \
        if awk '!/^[[:space:]]*#/' "{{FLAKE}}/hosts/{{HOST}}/default.nix" | grep -Fq "self.modules.nixos.\"$module\""; then \
            printf '%s  (current)\n' "$module"; \
        else \
            printf '%s\n' "$module"; \
        fi; \
    done
# ---------------------------------------------------------------------------
# Home Manager
# ---------------------------------------------------------------------------

# Home Manager is activated as part of the NixOS switch in this architecture.
[group('home-manager')]
[linux]
hm-restart:
    sudo systemctl restart "home-manager-$(id -un).service"

[group('home-manager')]
[linux]
hm-status:
    systemctl status "home-manager-$(id -un).service" --no-pager

[group('home-manager')]
[linux]
hm-logs:
    journalctl -u "home-manager-$(id -un).service" -b --no-pager -n 150

# ---------------------------------------------------------------------------
# nix-darwin
# ---------------------------------------------------------------------------

[group('darwin')]
[macos]
darwin-eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#darwinConfigurations.\"{{DARWIN_HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('darwin')]
[macos]
darwin-build:
    {{NIX_ALLOW}} nh darwin build "{{FLAKE}}" -H "{{DARWIN_HOST}}" -- --impure

[group('darwin')]
[macos]
darwin-switch:
    {{NIX_ALLOW}} nh darwin switch "{{FLAKE}}" -H "{{DARWIN_HOST}}" -- --impure

[group('darwin')]
[macos]
darwin-repl:
    {{NIX_ALLOW}} nix repl "{{FLAKE}}" --impure

# ---------------------------------------------------------------------------
# Store maintenance
# ---------------------------------------------------------------------------

[group('store')]
gc:
    nix-collect-garbage --delete-older-than 7d
    sudo nix-collect-garbage --delete-older-than 7d

[group('store')]
gc-user:
    nix-collect-garbage --delete-older-than 7d

[group('store')]
gc-system:
    sudo nix-collect-garbage --delete-older-than 7d

[group('store')]
gc-roots:
    ls -lah /nix/var/nix/gcroots/auto/

[group('store')]
store-verify:
    nix store verify --all

[group('store')]
store-optimize:
    nix store optimise

# ---------------------------------------------------------------------------
# Development / secrets
# --------------------------------------------------------------------------------------

[group('dev')]
dev:
    nix develop "{{FLAKE}}"

[group('dev')]
rekey:
    cd "{{FLAKE}}" && agenix-rekey

[group('dev')]
rekey-status:
    cd "{{FLAKE}}" && git status --short
