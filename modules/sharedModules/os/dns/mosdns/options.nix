{
  lib,
  pkgs,
  config,
  ...
}:
let
  formatYaml = pkgs.formats.yaml { };

  cfg = config.profiles.services.dns;
in
{
  options.profiles.services.dns = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable the DNS service.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.mosdns;
    };

    listen = lib.mkOption {
      type = lib.types.str;
      default = ":53";
      description = "The address and port to listen on.";
    };

    settings = lib.mkOption {
      default = { };
      type = formatYaml.type;
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mosdns
    ];
  };

}
