{
  pkgs,
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.modules'.virtual.docker;
in
{
  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.podman-desktop
    ];

    users.users."${username}" = {
      extraGroups = lib.mkAfter [
        "docker"
        "podman"
      ];
    };

    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork = {
          settings = {
            dns_enabled = true;
          };
        };
        # networkSocket = {
        #   enable = true;
        # };
      };
      docker = {
        enable = false;
        daemon.settings = {
          # enables pulling using containerd, which supports restarting from a partial pull
          # https://docs.docker.com/storage/containerd/
          "features" = {
            "containerd-snapshotter" = true;
          };
        };
        # rootless = {
        #   enable = true;
        #   setSocketVariable = true;
        # };

        # start dockerd on boot.
        # This is required for containers which are created with the `--restart=always` flag to work.
        enableOnBoot = true;
        storageDriver = "btrfs";
      };
    };
  };
}
