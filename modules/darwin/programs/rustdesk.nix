{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.packages;
in
{
  options.modules'.packages = with lib; {
    rustdesk = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable packages module";
      };
    };
  };

  config = lib.mkIf cfg.rustdesk.enable {
    homebrew.casks = [ "rustdesk" ];
  };
}
