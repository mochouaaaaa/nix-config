{ lib, ... }:
let
  installDiskDevice = builtins.getEnv "INSTALL_DISK_DEVICE";
in
{
  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault (if installDiskDevice != "" then installDiskDevice else "/dev/vda");

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
              # Keep the Btrfs top-level available for administration.
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
}
