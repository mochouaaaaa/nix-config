{
  lib,
  config,
  ...
}:
{

  config = lib.mkIf (!config.profiles.wsl.enable) {

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
