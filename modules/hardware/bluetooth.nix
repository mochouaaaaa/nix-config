{
  flake.modules.nixos."hardware.bluetooth" =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        bluetuith
      ];

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        input = {
          General = {
            UserspaceHID = true;
          };
        };
        settings = {
          General = {
            AutoEnable = true;
            Enable = "Source,Sink,Media,Socket";
            Experimental = true;
            DiscoverableTimeout = 0;
            PairableTimeout = 0;
          };
          LE = {
            MinConnectionInterval = 16;
            MaxConnectionInterval = 16;
            ConnectionLatency = 10;
            ConnectionSupervisionTimeout = 100;
          };
        };
      };

      profiles.preservation.directories = [
        "/var/lib/bluetooth"
      ];

    };

}
