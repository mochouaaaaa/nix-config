{
  flake.aspects."core"."nixos" =
    {
      lib,
      config,
      ...
    }:
    {
      boot = {
        tmp.cleanOnBoot = lib.mkDefault ((config.fileSystems."/".fsType or "") != "tmpfs");

        loader = {
          systemd-boot = {
            configurationLimit = lib.mkDefault 10;
            consoleMode = lib.mkDefault "max";
          };
          timeout = lib.mkDefault 10;
        };

      };

      services.bootvine = {
        enable = true;
      };

    };
}
