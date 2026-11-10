{
  flake.modules.nixos.core =
    {
      lib,
      config,
      ...
    }:
    {
      boot = {
        tmp.cleanOnBoot = (config.fileSystems."/".fsType or "") != "tmpfs";

        kernelModules = [
          "uhid"
          "hidp"
          "hid_multitouch"
          "snd_aloop"
        ];

        loader = {
          systemd-boot = {
            configurationLimit = lib.mkDefault 10;
            consoleMode = lib.mkDefault "max";
          };
          timeout = lib.mkDefault 10;
        };

      };
    };
}
