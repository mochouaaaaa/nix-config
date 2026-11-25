# Mochou Nix configuration tasks
# Usage:
#   just                 Show available recipes
#   just check           Evaluate flake outputs without building derivations
#   just eval            Evaluate the current platform's system configuration
#   just build           Build the current platform's system
#   just switch          Switch the current platform's system
#
# Override defaults when needed:
#   NH_FLAKE=/path/to/nix just check
#   NH_HOST=mochou@nixos just switch
#   NH_HOST=mochou@darwin just switch

set shell := ["bash", "-cu"]

# The repository containing this justfile.
FLAKE := env_var_or_default("NH_FLAKE", justfile_directory())

# Use one host selector on both platforms. Only the default differs.
HOST := env_var_or_default("NH_HOST", if os() == "macos" { "mochou@darwin" } else { "mochou@nixos" })

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
    NIX_CONFIG_CHECK=1 {{NIX_ALLOW}} nix flake show "{{FLAKE}}" --impure

[group('flake')]
lock:
    nix flake lock "{{FLAKE}}"

[group('flake')]
update:
    nix flake update "{{FLAKE}}"

# Update the platform-specific input set under one recipe name.
[group('flake')]
[linux]
update-platform:
    nix flake update "{{FLAKE}}" nixpkgs nixpkgs-stable home-manager nixos-wsl disko

[group('flake')]
[macos]
update-platform:
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

# Evaluate the configured host on the current platform.
[group('quality')]
[linux]
[macos]
validate-hosts: eval

# ---------------------------------------------------------------------------
# System configuration
# ---------------------------------------------------------------------------

# Shared recipe names and arguments; only the platform-specific command differs.
[group('system')]
[linux]
eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('system')]
[macos]
eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#darwinConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

[group('system')]
[linux]
build:
    {{NIX_ALLOW}} nh os build "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[macos]
build:
    {{NIX_ALLOW}} nh darwin build "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[linux]
switch:
    {{NIX_ALLOW}} nh os switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[macos]
switch:
    {{NIX_ALLOW}} nh darwin switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[linux]
boot:
    {{NIX_ALLOW}} nh os boot "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[linux]
test:
    {{NIX_ALLOW}} nh os test "{{FLAKE}}" -H "{{HOST}}" -- --impure

[group('system')]
[linux]
vm:
    vm_path=$({{NIX_ALLOW}} nix build "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.vmWithDisko" --impure --no-link --print-out-paths); \
    "$vm_path/bin/disko-vm"

[group('system')]
[linux]
repl:
    {{NIX_ALLOW}} nixos-rebuild repl --flake "{{FLAKE}}#{{HOST}}" --impure

[group('system')]
[macos]
repl:
    {{NIX_ALLOW}} nix repl "{{FLAKE}}" --impure

# ---------------------------------------------------------------------------
# Remote deployment
# ---------------------------------------------------------------------------

[group('remote')]
[linux]
remote_install ip port:
    INSTALL_HOST="root@{{ip}}" \
    INSTALL_SSH_PORT="{{port}}" \
    nix run "{{FLAKE}}#install-vm" --

# Keep the same positional arguments on both platforms.
# Linux deploy-rs uses SSH options for the requested port; Darwin builds
# directly on the remote NixOS store and activates the resulting toplevel.
[group('remote')]
[linux]
remote_deploy ip="192.168.122.62" port="22":
    cd "{{FLAKE}}" && deploy --hostname "{{ip}}" --ssh-opts="-p {{port}}" '.#remote.system'

[group('remote')]
[linux]
remote_deploy_dry ip="192.168.122.62" port="22":
    cd "{{FLAKE}}" && deploy --hostname "{{ip}}" --ssh-opts="-p {{port}}" --dry-activate '.#remote.system'

[group('remote')]
[macos]
remote_deploy ip="192.168.122.62" port="22":
    set -euo pipefail; \
    target="mochou@{{ip}}"; \
    toplevel=$(NIX_SSHOPTS="-p {{port}}" {{NIX_ALLOW}} nix build \
        "{{FLAKE}}#nixosConfigurations.\"mochou@remote\".config.system.build.toplevel" \
        --eval-store auto \
        --store "ssh-ng://$target" \
        --impure \
        --no-link \
        --print-out-paths); \
    echo "Build completed: $toplevel"; \
    ssh -p "{{port}}" -t "$target" \
        "sudo nix-env --profile /nix/var/nix/profiles/system --set '$toplevel' && \
         sudo '$toplevel/bin/switch-to-configuration' switch"; \
    echo "Remote NixOS deployment completed."

[group('remote')]
[macos]
remote_deploy_dry ip="192.168.122.62" port="22":
    set -euo pipefail; \
    target="mochou@{{ip}}"; \
    toplevel=$(NIX_SSHOPTS="-p {{port}}" {{NIX_ALLOW}} nix build \
        "{{FLAKE}}#nixosConfigurations.\"mochou@remote\".config.system.build.toplevel" \
        --eval-store auto \
        --store "ssh-ng://$target" \
        --impure \
        --no-link \
        --print-out-paths); \
    echo "Build completed: $toplevel"; \
    ssh -p "{{port}}" -t "$target" \
        "sudo nix-env --profile /nix/var/nix/profiles/system --set '$toplevel' && \
         sudo '$toplevel/bin/switch-to-configuration' dry-activate"; \
    echo "Remote NixOS dry activation completed."

# List available NixOS desktop entry modules and mark the host's selected desktop.
[group('nixos')]
[linux]
desktop:
    @nix eval --raw --apply 'modules: builtins.concatStringsSep "\\n" (builtins.filter (name: builtins.match "desktop\\\\.[^.]+$" name != null && name != "desktop.common") (builtins.attrNames modules))' "{{FLAKE}}#modules.nixos" | while IFS= read -r module || [ -n "$module" ]; do \
        if awk '!/^[[:space:]]*#/' "{{FLAKE}}/hosts/{{HOST}}/default.nix" | grep -Fq "self.modules.nixos.\"$module\""; then \
            printf '%s  (current)\\n' "$module"; \
        else \
            printf '%s\\n' "$module"; \
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
# ---------------------------------------------------------------------------

[group('dev')]
dev:
    nix develop "{{FLAKE}}"

[group('dev')]
rekey:
    cd "{{FLAKE}}" && agenix-rekey

[group('dev')]
rekey-status:
    cd "{{FLAKE}}" && git status --short
