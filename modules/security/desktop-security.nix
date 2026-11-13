{
  flake.modules.nixos."security.desktop" = {
    security = {
      polkit.enable = true;

      pam.services = {
        swaylock = { };
        hyprlock = { };
      };
    };
  };
}
