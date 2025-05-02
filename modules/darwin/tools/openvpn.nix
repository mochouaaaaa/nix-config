{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.packages;
in
{
  options.modules.packages = with lib; {
    openvpn = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable packages module";
      };
    };
    tunnelblick = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    homebrew.casks = lib.mkAfter (
      lib.optionals cfg.openvpn.enable [ "openvpn-connect" ]
      ++ lib.optionals cfg.tunnelblick.enable [
        "tunnelblick"
      ]
    );
  };
}
