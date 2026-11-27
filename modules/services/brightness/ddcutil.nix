{
  flake.aspects."services.brightness"."nixos" = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ddcutil
    ];
    # "i2c-dev"  显示器亮度
    services.ddccontrol.enable = true;
  };

}
