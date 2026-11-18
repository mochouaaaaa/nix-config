{
  flake.modules.nixos."desktop.base" = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };
}
