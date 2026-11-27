{
  flake.aspects."security.desktop".nixos = {
    security = {
      polkit.enable = true;

      pam.services = {
        swaylock = { };
        hyprlock = { };
      };
    };
  };
}
