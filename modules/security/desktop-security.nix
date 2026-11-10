{
  flake.modules.nixos."desktop.common" = {
    security = {
      polkit.enable = true;

      pam.services = {
        swaylock = { };
        hyprlock = { };
      };
    };
  };
}
