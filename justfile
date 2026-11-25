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

# Root directory of the Flake; NH_FLAKE can point recipes at another checkout.
FLAKE := env_var_or_default("NH_FLAKE", justfile_directory())

# Host selected by system recipes; NH_HOST overrides the platform-specific default.
HOST := env_var_or_default("NH_HOST", if os() == "macos" { "mochou@darwin" } else { "mochou@nixos" })

# These are only needed by configurations that intentionally allow
# unfree/insecure packages. They are passed to Nix commands with --impure.
NIX_ALLOW := "NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_INSECURE=1"

# Show all recipes available on the current platform.
default:
    @just --list

# ---------------------------------------------------------------------------
# Repository / flake
# ---------------------------------------------------------------------------

# Display the Flake outputs and their evaluated descriptions.
[group('flake')]
show:
    NIX_CONFIG_CHECK=1 {{NIX_ALLOW}} nix flake show "{{FLAKE}}" --impure

# Update flake.lock inputs to the versions selected by the current lock configuration.
[group('flake')]
lock:
    nix flake lock "{{FLAKE}}"

# Update every Flake input to its latest version allowed by the input declarations.
[group('flake')]
update:
    nix flake update "{{FLAKE}}"

# Update the inputs used by the NixOS/Linux configurations.
[group('flake')]
[linux]
update-platform:
    nix flake update "{{FLAKE}}" nixpkgs nixpkgs-stable home-manager nixos-wsl disko

# Update the inputs used by the nix-darwin/macOS configurations.
[group('flake')]
[macos]
update-platform:
    nix flake update "{{FLAKE}}" nixpkgs-darwin nix-darwin home-manager-darwin

# Update the Plasma desktop manager input.
[group('flake')]
[linux]
update-desktop:
    nix flake update "{{FLAKE}}" plasma-manager

# List the host configuration directories under hosts/.
[group('flake')]
hosts:
    @find "{{FLAKE}}/hosts" -mindepth 1 -maxdepth 1 -type d -print | sort

# Print the selected host's default.nix for quick inspection.
[group('flake')]
host-config:
    @sed -n '1,220p' "{{FLAKE}}/hosts/{{HOST}}/default.nix"

# ---------------------------------------------------------------------------
# Quality checks
# ---------------------------------------------------------------------------

# Format Nix files using the formatter configured by the Flake.
[group('quality')]
fmt:
    nix fmt "{{FLAKE}}"

# Check Nix formatting without modifying files.
[group('quality')]
fmt-check:
    find "{{FLAKE}}" -path "{{FLAKE}}/.git" -prune -o -path "{{FLAKE}}/.direnv" -prune -o -name '*.nix' -print0 | xargs -0 -r nixfmt --check

# Run statix and deadnix to detect common Nix issues and unused code.
[group('quality')]
lint:
    cd "{{FLAKE}}" && statix check .
    cd "{{FLAKE}}" && deadnix --fail .

# Evaluate Flake checks across all systems without building their derivations.
[group('quality')]
check:
    NIX_CONFIG_CHECK=1 {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --no-build --impure --show-trace --all-systems

# Run Flake checks and build the derivations required by those checks.
[group('quality')]
check-build:
    {{NIX_ALLOW}} nix flake check "{{FLAKE}}" --impure --show-trace

# Run formatting, lint, and no-build Flake checks in sequence.
[group('quality')]
validate: fmt-check lint check

# Evaluate the selected host configuration for the current platform.
# Validate the selected host by evaluating its system toplevel derivation.
[group('quality')]
[linux]
[macos]
validate-hosts: eval

# ---------------------------------------------------------------------------
# System configuration
# ---------------------------------------------------------------------------

# Evaluate the selected NixOS toplevel and print its derivation path; do not build it.
[group('system')]
[linux]
eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

# Evaluate the selected nix-darwin toplevel and print its derivation path; do not build it.
[group('system')]
[macos]
eval:
    {{NIX_ALLOW}} nix eval "{{FLAKE}}#darwinConfigurations.\"{{HOST}}\".config.system.build.toplevel.drvPath" --impure --show-trace

# Build the selected NixOS system generation without activating it.
[group('system')]
[linux]
build:
    {{NIX_ALLOW}} nh os build "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Build the selected nix-darwin system generation without activating it.
[group('system')]
[macos]
build:
    {{NIX_ALLOW}} nh darwin build "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Build and activate the selected NixOS configuration immediately.
[group('system')]
[linux]
switch:
    {{NIX_ALLOW}} nh os switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Build and activate the selected nix-darwin configuration immediately.
[group('system')]
[macos]
switch:
    {{NIX_ALLOW}} nh darwin switch "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Build the selected NixOS generation and make it the default for the next boot.
[group('system')]
[linux]
boot:
    {{NIX_ALLOW}} nh os boot "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Activate the selected NixOS configuration temporarily for testing; it is not made the boot default.
[group('system')]
[linux]
test:
    {{NIX_ALLOW}} nh os test "{{FLAKE}}" -H "{{HOST}}" -- --impure

# Build and launch the selected NixOS VM configuration, including its Disko disk setup.
[group('system')]
[linux]
vm:
    vm_path=$({{NIX_ALLOW}} nix build "{{FLAKE}}#nixosConfigurations.\"{{HOST}}\".config.system.build.vmWithDisko" --impure --no-link --print-out-paths); \
    "$vm_path/bin/disko-vm"

# Open the NixOS rebuild REPL with the selected host's configuration available.
[group('system')]
[linux]
repl:
    {{NIX_ALLOW}} nixos-rebuild repl --flake "{{FLAKE}}#{{HOST}}" --impure

# Open an interactive Nix REPL with this Flake loaded.
[group('system')]
[macos]
repl:
    {{NIX_ALLOW}} nix repl "{{FLAKE}}" --impure

# ---------------------------------------------------------------------------
# Remote deployment
# ---------------------------------------------------------------------------

# Install or reinstall the remote NixOS host; this runs nixos-anywhere and reformats the selected disk.
[group('remote')]
[linux]
remote_install ip port:
    INSTALL_HOST="root@{{ip}}" \
    INSTALL_SSH_PORT="{{port}}" \
    nix run "{{FLAKE}}#remote_install" --

# Keep the same positional arguments on both platforms.
# Linux deploy-rs uses SSH options for the requested port; Darwin builds
# directly on the remote NixOS store and activates the resulting toplevel.
# Deploy the remote NixOS system through deploy-rs using the supplied address and SSH port.
[group('remote')]
[linux]
remote_deploy ip="192.168.122.62" port="22":
    cd "{{FLAKE}}" && deploy --hostname "{{ip}}" --ssh-opts="-p {{port}}" '.#remote.system'

# Build and dry-activate the remote NixOS deployment without switching it permanently.
[group('remote')]
[linux]
remote_deploy_dry ip="192.168.122.62" port="22":
    cd "{{FLAKE}}" && deploy --hostname "{{ip}}" --ssh-opts="-p {{port}}" --dry-activate '.#remote.system'

# Build the remote NixOS toplevel on the target store over SSH, then activate it remotely.
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


# List available NixOS desktop modules and mark the module selected by the current host.
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
# Restart the current user's Home Manager systemd service.
[group('home-manager')]
[linux]
hm-restart:
    sudo systemctl restart "home-manager-$(id -un).service"

# Show the current user's Home Manager systemd service status.
[group('home-manager')]
[linux]
hm-status:
    systemctl status "home-manager-$(id -un).service" --no-pager

# Show the latest 150 log lines for the current user's Home Manager service.
[group('home-manager')]
[linux]
hm-logs:
    journalctl -u "home-manager-$(id -un).service" -b --no-pager -n 150

# ---------------------------------------------------------------------------
# Store maintenance
# ---------------------------------------------------------------------------

# Collect garbage older than seven days from both the user and system profiles.
[group('store')]
gc:
    nix-collect-garbage --delete-older-than 7d
    sudo nix-collect-garbage --delete-older-than 7d

# Collect garbage older than seven days from the current user's profile.
[group('store')]
gc-user:
    nix-collect-garbage --delete-older-than 7d

# Collect garbage older than seven days from the system profile (requires sudo).
[group('store')]
gc-system:
    sudo nix-collect-garbage --delete-older-than 7d

# List automatic Nix garbage-collector roots.
[group('store')]
gc-roots:
    ls -lah /nix/var/nix/gcroots/auto/

# Verify the integrity of all paths in the Nix store.
[group('store')]
store-verify:
    nix store verify --all

# Deduplicate identical files in the Nix store to reclaim disk space.
[group('store')]
store-optimize:
    nix store optimise

# ---------------------------------------------------------------------------
# Development / secrets
# ---------------------------------------------------------------------------

# Enter the general development shell defined by this Flake.
[group('dev')]
dev:
    cd "{{FLAKE}}" && nix develop "{{FLAKE}}"

# Enter the dedicated Agenix environment with age and agenix-rekey available.
[group('agenix')]
agenix:
    cd "{{FLAKE}}" && nix develop "{{FLAKE}}#agenix"

