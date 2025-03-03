{
  lib,
  config,
  myvars,
  ...
}: {
  imports = [../dm/greetd.nix];
  programs.hyprland = {
    enable = myvars.desktop.hyprland;
  };

  services = {
    xserver = {
      enable = true;
    };
    greetd = {
      settings = {
        default_session = {
          command = lib.mkForce "${lib.getExe config.programs.hyprland.package}";
        };
      };
    };
  };
}
