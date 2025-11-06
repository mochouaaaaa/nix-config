{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages.tencent.feishu;
  isdekstop = config.programs.desktop.enable;
in
{
  options.modules'.packages.tencent = {
    wemeet = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable WeMeet.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        # default = pkgs.nur.repos.linyinfeng.wemeet;
        default = pkgs.wemeet;
      };
    };
  };

  config = lib.mkIf (cfg.enable && isdekstop) {
    home.packages = [ cfg.package ];
  };
}
