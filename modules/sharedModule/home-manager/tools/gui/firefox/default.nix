{ lib, ... }:
{
  imports = lib.importModule' ./.;

  options.modules' = {
    packages.firefox = with lib; {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the firefox package.";
      };
    };
  };

}
