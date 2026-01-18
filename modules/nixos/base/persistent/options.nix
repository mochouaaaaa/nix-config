{ lib, config, ... }:
{
  options.profiles.persistent = with lib; {
    enable = mkOption {
      type = types.bool;
      readOnly = true;
      default = (config.fileSystems."/".fsType or "") == "tmpfs";
    };
    osDirectories = mkOption rec {
      type = types.listOf (
        types.oneOf [
          types.str
          types.attrs
        ]
      );
      default = [ ];
      description = "List of directories to preserve across reboots.";
      apply = userValue: default ++ userValue;
    };
    hmDirectories = mkOption rec {
      type = types.listOf (
        types.oneOf [
          types.str
          types.attrs
        ]
      );
      default = [ ];
      description = "List of directories to preserve across reboots for Home Manager Profiles.";
      apply = userValue: default ++ userValue;
    };
  };

}
