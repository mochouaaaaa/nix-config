{
  flake.aspects.security.provides.desktop.nixos = {
    security = {
      polkit.enable = true;

      pam.services = {
        swaylock = { };
        hyprlock = { };
      };
    };
  };
}
