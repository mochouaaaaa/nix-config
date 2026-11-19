{
  flake.modules.homeManager."desktop.gnome" = { pkgs, ... }: {
    programs = {
      gnome-shell = {
        extensions = [
          { package = pkgs.gnomeExtensions.vicinae; }
        ];
      };
    };
  };

}
