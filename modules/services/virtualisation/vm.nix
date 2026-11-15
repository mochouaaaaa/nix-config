{
  flake.modules.nixos."services.virtualisation.vm" =
    {
      inputs,
      lib,
      pkgs,
      self,
      username,
      ...
    }:
    let
      vmConfig = {
        imports = [ self.modules.nixos.appearance ];

        # The VM is disposable; do not inherit the host's preservation setup.
        profiles.preservation.enable = lib.mkForce false;

        # The VM is built on the host, so force the guest Home Manager user
        # to use the flake-pinned dotfiles input instead of host-local paths.
        home-manager.users.${username}.profiles.dotfiles = lib.mkForce inputs.dotfiles;
        home-manager.useUserPackages = lib.mkForce true;

        programs.hyprland.enable = lib.mkForce false;
        services.xserver.enable = lib.mkForce false;
        services.displayManager.noctalia-greeter.enable = lib.mkForce false;

        environment.systemPackages = [ pkgs.bat ];

        fonts.packages = with pkgs; [
          noto-fonts-cjk-sans
          source-han-sans
          source-han-serif
        ];

        # Keep the EnvironmentFile paths provided by the agenix module.
        # This lets the VM use the real encrypted secrets after decryption.
      };
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      # Disko's device definition belongs to the host module configuration.
      # Disable its automatic fileSystems generation here: these devices are
      # only used by vmVariantWithDisko to create an isolated VM disk image.
      disko = {
        enableConfig = false;
        tests.efi = true;

        # Extra configuration is imported by Disko's vmVariantWithDisko.
        # Keep host-side port forwarding here so it reaches the generated VM.
        tests.extraConfig.virtualisation.forwardPorts = [
          {
            from = "host";
            host.address = "127.0.0.1";
            host.port = 2223;
            guest.port = 22;
          }
        ];

        devices.disk.main = {
          type = "disk";
          device = "/dev/vda";
          imageSize = "32G";

          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "1025M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              swap = {
                size = "10G";
                content = {
                  type = "swap";
                };
              };

              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    # Mount the Btrfs top-level subvolume for filesystem
                    # administration, snapshots, and send/receive operations.
                    "/" = {
                      mountpoint = "/btr_pool";
                      mountOptions = [ "subvolid=5" ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd"
                      ];
                    };

                    "/@rootfs" = {
                      mountpoint = "/nix/persistence";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd"
                      ];
                    };

                    "/@home" = {
                      mountpoint = "/nix/persistence/home";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd"
                      ];
                    };

                    "/@var" = {
                      mountpoint = "/nix/persistence/var";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };

      # The VM-specific options are applied to the Disko-generated guest.
      virtualisation.vmVariantWithDisko = vmConfig // {
        # Disko generates swapDevices from the 10 GiB swap partition.
        # Do not override it here, otherwise the guest will not activate swap.

        # Keep the same ephemeral root model as the host, without using
        # the host's physical root partition.
        # qemu-vm derives guest fileSystems from virtualisation.fileSystems.
        # With useDefaultFilesystems disabled, declare the tmpfs root here.
        virtualisation.fileSystems."/" = {
          device = "tmpfs";
          fsType = "tmpfs";
          options = [
            "relatime"
            "mode=755"
          ];
        };
      };
    };
}
