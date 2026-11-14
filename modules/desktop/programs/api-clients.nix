{
  flake.modules.homeManager."desktop.programs.api-clients" = { pkgs, ... }: {
    home.packages = [
      pkgs.hoppscotch
    ];
  };

  # Cartero is a Linux-only GUI application.
  flake.modules.homeManager."desktop.programs.api-clients.gui" = { pkgs, ... }: {
    home.packages = [ pkgs.cartero ];
  };
}
