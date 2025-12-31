{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.network.proxy.sparkle;
in
{
  options.modules'.network.proxy.sparkle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable clash-party proxy.";
    };
  };

  config = lib.mkIf (config.programs.desktop.enable && cfg.enable) {

    modules'.persistent.hmDirectories = [
      ".config/sparkle"
    ];

    environment = {
      systemPackages = with pkgs; [
        sparkle
        (makeAutostartItem {
          name = "sparkle";
          package = pkgs.sparkle;
        })
      ];
    };

    security.wrappers.sparkle = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
      source = "${lib.getExe pkgs.sparkle}";
    };

  };
}
