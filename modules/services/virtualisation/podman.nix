{
  flake.modules.nixos."services.virtualisation.podman" =
    {
      lib,
      pkgs,
      config,

      username,
      ...
    }:
    {

      config = lib.mkMerge [

        {
          environment.systemPackages = [
            # pkgs.podman-desktop
            pkgs.docker-compose # 配合 Podman 的 dockerSocket 使用
          ];

          users.users.${username}.extraGroups = [
            "podman"
          ];

          services.cockpit = rec {
            enable = false;
            port = 8099;

            settings = {
              WebService = {
                Origins = lib.mkForce "http://127.0.0.1:${port} https://127.0.0.1:${port} http://localhost:${port} https://localhost:${port}";
                ProtocolHeader = "X-Forwarded-Proto";
                AllowUnencrypted = true;
              };
            };
            plugins = with pkgs; [
              cockpit-podman
              cockpit-machines
              cockpit-files
            ];
          };

          virtualisation = {
            containers.enable = true; # 启用 /etc/containers 下的通用配置文件

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
            };

            # Docker 关闭，不配置任何 Docker 选项
            docker.enable = false;
          };

        }

        (lib.mkIf (config ? home-manager) {
          home-manager.users.${username} = {
            home.shellAliases.lazydocker = ''DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock" lazydocker'';

            programs.lazydocker = {
              enable = true;
            };
          };
        })

      ];

    };

  flake.modules.nixos.preservation = { lib, config, ... }: {
    # Podman 的持久化目录（不是 Docker）
    profiles.preservation.directories = lib.optionals config.virtualisation.podman.enable [
      "/var/lib/cni"
      "/var/lib/containers"
    ];
  };

}
