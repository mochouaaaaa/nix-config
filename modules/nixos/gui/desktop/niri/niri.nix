{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../dm/greetd.nix];
  services = {
    xserver = {
      enable = true;
    };
    greetd = {
      settings = {
        default_session = {
          command = lib.mkForce "${lib.getExe config.programs.niri.package}";
        };
      };
    };
  };
}
