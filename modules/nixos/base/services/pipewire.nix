{pkgs, ...}: {
  #============================= Audio(PipeWire) =======================

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pamixer
    pulseaudio # provides `pactl`, which is required by some apps(e.g. sonic-pi)
  ];

  # PipeWire is a new low-level multimedia framework.
  # It aims to offer capture and playback for both audio and video with minimal latency.
  # It support for PulseAudio-, JACK-, ALSA- and GStreamer-based applications.
  # PipeWire has a great bluetooth support, it can be a good alternative to PulseAudio.
  #     https://nixos.wiki/wiki/PipeWire
  services.pipewire = {
    enable = true;
    # package = pkgs-unstable.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # Disable pulseaudio, it conflicts with pipewire too.
  services = {
    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
      configFile = pkgs.writeText "default.pa" ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
        ## module fails to load with
        ##   module-bluez5-device.c: Failed to get device path from module arguments
        ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
        # load-module module-bluez5-device
        # load-module module-bluez5-discover
      '';

      extraConfig = "
      load-module module-switch-on-connect
    ";
    };
  };

  #============================= Bluetooth =============================
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
      LE = {
        MinConnectionInterval = 16;
        MaxConnectionInterval = 16;
        ConnectionLatency = 10;
        ConnectionSupervisionTimeout = 100;
      };
    };
  };
  services.blueman.enable = true;

  #================================= Misc =================================

  services = {
    printing.enable = true; # Enable CUPS to print documents.
    geoclue2.enable = true; # Enable geolocation services.

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput"
    '';

    udev.packages = with pkgs; [
      gnome-settings-daemon
      platformio # udev rules for platformio
      openocd # required by paltformio, see https://github.com/NixOS/nixpkgs/issues/224895
      android-udev-rules # required by adb
      openfpgaloader
    ];
  };
}
