{
  flake.modules.nixos."services.base" = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.upterm ];
    services.uptermd = {
      enable = true;
      listenAddress = "127.0.0.1"; # 或内网地址，按需改
      openFirewall = false; # 手动控制防火墙
    };
  };

}
