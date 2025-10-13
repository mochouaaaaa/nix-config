{ pkgs, ... }:
{

  config = {

    home.packages = [
      pkgs.loupe
    ];

    xdg.mimeApps = {
      defaultApplications = {
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
      };
    };

  };

}
