{
  flake.modules.nixos.core =
    { lib, ... }:
    let
      # en_US.UTF-8
      locale = "zh_CN.UTF-8";
    in
    {

      time.timeZone = "Asia/Shanghai";

      i18n = {
        defaultLocale = locale;
        extraLocaleSettings = lib.genAttrs [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ] (_: locale);
      };

    };
}
