{
  flake.modules.nixos."services.virtualisation.podman" =
    {
      pkgs,

      username,
      ...
    }:
    {

      environment.systemPackages = [
        pkgs.podman-desktop
        pkgs.docker-compose # 配合 Podman 的 dockerSocket 使用
      ];

      users.users.${username}.extraGroups = [
        "podman"
      ];

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

      # Podman 的持久化目录（不是 Docker）
      profiles.preservation.directories = [
        "/var/lib/containers"
      ];
    };
}
