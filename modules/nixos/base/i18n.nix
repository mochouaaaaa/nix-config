{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.i18n;
in
{

  options.profiles.i18n = {
    locale = lib.mkOption {
      type = lib.types.enum [
        "zh_CN"
        "en_US"
      ];
      default = "zh_CN";
    };
  };

  config = {

    # warnings = [
    #   "module lib version: ${lib.version}"
    #   "pkgs lib version: ${pkgs.lib.version}"
    #   "module lib path: ${toString lib.path}"
    #   "pkgs path: ${toString pkgs.path}"
    # ];

    # assertions = [
    #   {
    #     assertion = lib.version == pkgs.lib.version;
    #     message = "NixOS module lib and pkgs.lib versions differ";
    #   }
    #   {
    #     assertion = lib ? services;
    #     message = "NixOS lib.services missing";
    #   }
    #   {
    #     assertion = lib ? importService;
    #     message = "NixOS lib.importService missing";
    #   }
    #   # {
    #   #   assertion = lib.services ? configure;
    #   #   message = "NixOS lib.services.configure missing";
    #   # }
    #   {
    #     assertion = pkgs.lib ? importService;
    #     message = "NixOS pkgs.lib.importService missing";
    #   }
    # ];

    i18n =
      let
        locale = "${cfg.locale}.UTF-8";
      in
      {
        # Select internationalisation properties.
        defaultLocale = locale;

        extraLocaleSettings = {
          LC_ADDRESS = locale;
          LC_IDENTIFICATION = locale;
          LC_MEASUREMENT = locale;
          LC_MONETARY = locale;
          LC_NAME = locale;
          LC_NUMERIC = locale;
          LC_PAPER = locale;
          LC_TELEPHONE = locale;
          LC_TIME = locale;
        };
      };

  };
}
