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

    # Set your time zone.
    time.timeZone = "Asia/Shanghai";

    i18n = {
      # Select internationalisation properties.
      defaultLocale = "${cfg.locale}.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "${cfg.locale}.UTF-8";
        LC_IDENTIFICATION = "${cfg.locale}.UTF-8";
        LC_MEASUREMENT = "${cfg.locale}.UTF-8";
        LC_MONETARY = "${cfg.locale}.UTF-8";
        LC_NAME = "${cfg.locale}.UTF-8";
        LC_NUMERIC = "${cfg.locale}.UTF-8";
        LC_PAPER = "${cfg.locale}.UTF-8";
        LC_TELEPHONE = "${cfg.locale}.UTF-8";
        LC_TIME = "${cfg.locale}.UTF-8";
      };
    };

  };
}
