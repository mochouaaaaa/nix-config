{
  flake.modules.nixos."desktop.base" = { pkgs, ... }: {
    environment.variables.NIXOS_OZONE_WL = "1";
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };
}
