# Mochou Nix configuration tasks
# Usage:
#   just                 Show available recipes
#   just check           Evaluate flake outputs without building derivations
#   just nixos-switch    Switch the configured NixOS host
#
# Override defaults when needed:
#   NH_FLAKE=/path/to/nix just check
#   NH_HOST=mochou@nixos just nixos-switch

set shell := ["bash", "-cu"]

# The repository containing this justfile.
FLAKE := env_var_or_default("NH_FLAKE", justfile_directory())

# Host directory name under hosts/<username>@<platform>/.
# Override with NH_HOST when operating on another host.
HOST := env_var_or_default("NH_HOST", "mochou@nixos")

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
update-linux:
    nix flake update "{{FLAKE}}" nixpkgs nixpkgs-stable

[group('flake')]
update-darwin:
    nix flake update "{{FLAKE}}" nixpkgs-darwin nix-darwin

[group('flake')]
update-desktop:
    nix flake update "{{FLAKE}}" niri hyprland plasma-manager

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
    {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --no-build --impure --show-trace

[group('quality')]
check-build:
    {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --impure --show-trace

[group('quality')]
validate: fmt-check lint check

# ---------------------------------------------------------------------------
# NixOS
# ---------------------------------------------------------------------------

[group('nixos')]
nixos-eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('nixos')]
nixos-build:
    {{NIX_ALLOW}} nh os build "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
nixos-boot:
    {{NIX_ALLOW}} nh os boot "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
nixos-switch:
    {{NIX_ALLOW}} nh os switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
nixos-test:
    {{NIX_ALLOW}} nh os test "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('nixos')]
nixos-repl:
    {{NIX_ALLOW}} nixos-rebuild repl --flake "{{FLAKE}}#{{HOST}}" --impure

# Inspect which desktop NixOS module is selected in the host's default.nix.
[group('nixos')]
desktop:
    @grep -nE 'modules\.nixos\."?desktop\.' "{{FLAKE}}/hosts/{{HOST}}/default.nix" || true

# ---------------------------------------------------------------------------
# Home Manager
# ---------------------------------------------------------------------------

# Home Manager is activated as part of the NixOS switch in this architecture.
[group('home-manager')]
hm-restart:
    sudo systemctl restart "home-manager-$(id -un).service"

[group('home-manager')]
hm-status:
    systemctl status "home-manager-$(id -un).service" --no-pager

[group('home-manager')]
hm-logs:
    journalctl -u "home-manager-$(id -un).service" -b --no-pager -n 150

# ---------------------------------------------------------------------------
# nix-darwin
# ---------------------------------------------------------------------------

[group('darwin')]
darwin-eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#darwinConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('darwin')]
darwin-build:
    {{NIX_ALLOW}} nh darwin build "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('darwin')]
darwin-switch:
    {{NIX_ALLOW}} nh darwin switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('darwin')]
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

