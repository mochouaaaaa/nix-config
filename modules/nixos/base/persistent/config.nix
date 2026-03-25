{
  config,
  username,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.persistent;
in
{

  imports = [
    inputs.preservation.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {

    # pverservation required initrd using systemd.
    boot.initrd.systemd.enable = true;

    preservation = {
      enable = true;
      preserveAt."/nix/persistence" = {

        directories = [
          "/var/lib/sbctl" # lanzaboote - secure boot
          # "/var/log"

          # system-core
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
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
        ++ lib.optionals (!config.system.etc.overlay.enable) [
          "/etc/NetworkManager/system-connections"
          "/etc/ssh"
        ]
        ++ cfg.osDirectories;

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
            ".ollama"
            ".config/dotfile"
            ".local/share/direnv"
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

            # ======================================
            # Misc
            # ======================================
            # services
            ".cache/cliphist"

          ]
          ++ cfg.hmDirectories;

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
        "/nix/persistence/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /nix/persistence"
      ];
    };

  };

}
