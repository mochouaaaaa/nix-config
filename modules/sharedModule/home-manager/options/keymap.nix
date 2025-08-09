{ lib, ... }:
{

  options.modules' = with lib; {

    keymaps = mkOption {
      type = types.submodule {
        options = {
          Super = mkOption {
            type = types.str;
            default = "cmd";
            description = "The key used for the super key.";
          };
        };
      };
      description = "Key mappings configuration.";
    };

  };

}
