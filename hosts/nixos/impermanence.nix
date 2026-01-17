{
  config,
  username,
  lib,
  ...
}:
let
  isTmpfsRoot = (config.fileSystems."/".fsType or "") == "tmpfs";
  cfgPersistent = config.profiles.persistent;
in

{

  options.profiles.persistent = with lib; {
    osDirectories = mkOption rec {
      type = types.listOf (
        types.oneOf [
          types.str
          types.attrs
        ]
      );
      default = [ ];
      description = "List of directories to preserve across reboots.";
      apply = userValue: default ++ userValue;
    };
    hmDirectories = mkOption rec {
      type = types.listOf (
        types.oneOf [
          types.str
          types.attrs
        ]
      );
      default = [ ];
      description = "List of directories to preserve across reboots for Home Manager Profiles.";
      apply = userValue: default ++ userValue;
    };
  };

  config = lib.mkIf isTmpfsRoot {

    # pverservation required initrd using systemd.
    boot.initrd.systemd.enable = true;

    preservation = {
      enable = true;
      preserveAt."/nix/persistence" = {

        directories = [
          "/etc/NetworkManager/system-connections"
          "/etc/ssh"
          "/var/lib/sbctl" # lanzaboote - secure boot

          "/var/log"

          # system-core
          "/var/lib/nixos"
          "/var/lib/systemd"

          # containers
          "/var/lib/cni"
          "/var/lib/containers"
          "/var/lib/flatpak"
          ".var"

          # virtualisation
          "/var/lib/libvirt"
          "/var/lib/lxc"
          "/var/lib/lxd"
          "/var/lib/qemu"

          # network
          "/var/lib/tailscale"
          "/var/lib/bluetooth"
          "/var/lib/NetworkManager"
          "/var/lib/iwd"
        ]
        ++ cfgPersistent.osDirectories;

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        users.${username} = {
          commonMountOptions = [
            "x-gvfs-hide"
          ];
          directories = [
            # ======================================
            # XDG Directories
            # ======================================
            "Downloads"
            "Music"
            "Pictures"
            "Public"
            "Documents"
            "Videos"

            # ======================================
            # Work / dotfiles
            # ======================================
            "Code"
            "nix"
            ".config/dotfile"
            ".config/env"
            ".local/share/direnv"
            ".local/share/devenv"
            ".tmux"
            "tmp"

            # ======================================
            # Nix / Home Manager Profiles
            # ======================================

            ".local/state/home-manager"
            ".local/state/nix/profiles"
            ".local/share/nix"
            ".cache/nix"
            ".cache/nixpkgs-review"

            # ======================================
            # IDE / Editors
            # ======================================
            # nvim
            ".local/share/nvim"
            ".local/state/nvim"
            ".local/nvim/catppuccin"
            ".wakatime"
            ".config/github-copilot"

            # ======================================
            # Language config
            # ======================================
            ".npm"
            ".yarn"
            ".local/share/cargo"
            ".local/share/rustup"
            ".local/share/uv"
            ".cache/uv"
            ".local/bin"

            # ======================================
            # Security
            # ======================================
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
            {
              directory = ".pki";
              mode = "0700";
            }
            ".local/share/keyrings"

            # ======================================
            # Misc
            # ======================================
            # services
            ".cache/cliphist"

          ]
          ++ cfgPersistent.hmDirectories;

          files = [
            ".zsh_history"
            ".zsh_history.new"
          ];
        };
      };

    };

    # Create some directories with custom permissions.
    #
    # In this configuration the path `/home/butz/.local` is not an immediate parent
    # of any persisted file so it would be created with the systemd-tmpfiles default
    # ownership `root:root` and mode `0755`. This would mean that the user `butz`
    # could not create other files or directories inside `/home/butz/.local`.
    #
    # Therefore systemd-tmpfiles is used to prepare such directories with
    # appropriate permissions.
    #
    # Note that immediate parent directories of persisted files can also be
    # configured with ownership and permissions from the `parent` settings if
    # `configureParent = true` is set for the file.
    systemd.tmpfiles.settings.preservation =
      let
        permission = {
          user = username;
          group = "users";
          mode = "0755";
        };
      in
      {
        "/home/${username}/.config".d = permission;
        "/home/${username}/.cache".d = permission;
        "/home/${username}/.local".d = permission;
        "/home/${username}/.local/share".d = permission;
        "/home/${username}/.local/state".d = permission;
        "/home/${username}/.local/state/nix".d = permission;
        "/home/${username}/.terraform.d".d = permission;
      };

    # systemd-machine-id-commit.service would fail but it is not relevant
    # in this specific setup for a persistent machine-id so we disable it
    #
    # see the firstboot example below for an alternative approach
    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

    # let the service commit the transient ID to the persistent volume
    systemd.services.systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persistent/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persistent"
      ];
    };

  };

}
