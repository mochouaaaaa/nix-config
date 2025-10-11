{ lib, config, ... }:
{
  imports = lib.importModule' ./.;

  options.modules' = {
    packages.firefox = with lib; {
      enable = mkOption {
        type = types.bool;
        default = (false && !config.programs.wsl.enable);
        description = "Whether to enable the firefox package.";
      };
    };
  };

}
