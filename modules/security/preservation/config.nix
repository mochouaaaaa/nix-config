{
  flake.modules.nixos.preservation =
    {
      lib,
      inputs,
      config,
      username,
      ...
    }:
    let
      cfg = config.profiles.preservation;
    in
    {
      imports = [
        inputs.preservation.nixosModules.default
      ];

      config = lib.mkIf cfg.enable {

        system.etc.overlay.enable = true;
        system.nixos-init.enable = config.system.etc.overlay.enable;
        services.userborn.enable = config.system.etc.overlay.enable;

        preservation.enable = true;
        preservation.preserveAt.${cfg.storagePath} = {
          inherit (cfg) directories files;
          users.${username} = cfg.users.${username} or { };
        };

        profiles.preservation = {
          directories = [
            "/var/lib/sbctl" # lanzaboote - secure boot

            # system-core
            {
              directory = "/var/lib/nixos";
              inInitrd = true;
            }
            "/var/lib/systemd"

            # containers
            "/var/lib/cni"
            "/var/lib/containers"
            ".var"

            # virtualisation
            "/var/lib/libvirt"
            "/var/lib/lxc"
            "/var/lib/lxd"

            # network
            "/var/lib/tailscale"
            "/var/lib/NetworkManager"
            "/var/lib/iwd"

          ]
          ++ lib.optionals (!config.system.etc.overlay.enable) [
            "/etc/NetworkManager/system-connections"
            "/etc/ssh"
          ];

          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
            }
          ];

          users.${username} = {
            commonMountOptions = [ "x-gvfs-hide" ];
            directories = [
              ".icons"

              # XDG Directories
              "Downloads"
              "Music"
              "Pictures"
              "Public"
              "Documents"
              "Videos"

              # Work / dotfiles
              "Code"
              "nix"
              ".config/dotfile"
              ".tmux"
              "tmp"

              # Nix / Home Manager Profiles
              # ".local/state/home-manager"
              # ".local/state/nix/profiles"
              # ".local/share/nix"
              # ".cache/nix"
              # ".cache/nixpkgs-review"

              # IDE / Editors
              ".wakatime"

              # Language config
              ".local/bin"

              # Security
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

              # Misc
              ".cache/cliphist"

            ];

            files = [
              ".zsh_history"
              ".zsh_history.new"
            ];
          };

        };

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

        systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

        systemd.services.systemd-machine-id-commit = {
          unitConfig.ConditionPathIsMountPoint = [
            ""
            "${cfg.storagePath}/etc/machine-id"
          ];
          serviceConfig.ExecStart = [
            ""
            "systemd-machine-id-setup --commit --root ${cfg.storagePath}"
          ];
        };

      };
    };
}
