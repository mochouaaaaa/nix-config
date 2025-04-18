{ pkgs, ... }:
{
  home.packages = with pkgs; [
    maple-mono
  ];

  fontConfig = {
    "org/gnome/desktop/interface" = {
      font-name = "Monaco Nerd Font";
      document-font-name = "Monaco Nerd Font";
      monospace-font-name = "Maple Mono NF";
      titlebar-font = "inter";
    };
  };
}
