{ lib, config, ... }:
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
