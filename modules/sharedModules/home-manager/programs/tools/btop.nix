{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.packages.btop;
in
{
  options.profiles.packages.btop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    programs = {
      btop = {
        enable = true;
        package = pkgs.btop;
      };
    };

  };
}
