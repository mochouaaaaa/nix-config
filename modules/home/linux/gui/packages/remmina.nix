{ pkgs, ... }:
{

  home.packages = with pkgs; [
    freerdp
  ];

  services.remmina = {
    enable = true;
  };
}
