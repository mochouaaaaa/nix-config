{
  flake.aspects."desktop.base".nixos = { pkgs, ... }: {
    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
    };
  };
}
