{
  flake.modules.nixos."desktop.common" = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };
}
