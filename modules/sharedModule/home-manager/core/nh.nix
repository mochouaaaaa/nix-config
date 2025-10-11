{
  pkgs,
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (!config.programs.wsl.enable) {

    programs.nh = rec {
      enable = true;
      clean = {
        enable = enable;
        dates = "weekly";
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };

  };
}
