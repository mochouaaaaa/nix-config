{
  config,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.gnome;
  monitors = config.programs.gnome.monitors;
in
{

  options.programs.gnome.monitors = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable monitors in GNOME";
    };
    monitorspec = {
      connector = lib.mkOption {
        type = lib.types.str;
        default = "DP-1";
        description = "The connector of the monitor";
      };
      vendor = lib.mkOption {
        type = lib.types.str;
        default = "GSM";
        description = "The vendor of the monitor";
      };
      product = lib.mkOption {
        type = lib.types.str;
        default = "LG HDR 4K";
        description = "The product of the monitor";
      };
      serial = lib.mkOption {
        type = lib.types.str;
        default = "0x00052c1d";
        description = "The serial of the monitor";
      };
    };
    scale = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "The scale of the monitor";
    };
    mode = {
      width = lib.mkOption {
        type = lib.types.int;
        default = 2560;
        description = "The width of the monitor";
      };
      height = lib.mkOption {
        type = lib.types.int;
        default = 1440;
        description = "The height of the monitor";
      };
      rate = lib.mkOption {
        type = lib.types.float;
        default = 59.961;
        description = "The refresh rate of the monitor";
      };
    };
    HDR = lib.mkOption {
      type = lib.types.int;
      default = 2100;
      description = "The HDR mode of the monitor";
    };
  };

  config = lib.mkIf (cfg.enable && monitors.enable) {
    xdg.configFile."monitors.xml".text = ''
      <monitors version="2">
        <configuration>
          <layoutmode>physical</layoutmode>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>${builtins.toString monitors.scale}</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>${monitors.monitorspec.connector}</connector>
                <vendor>${monitors.monitorspec.vendor}</vendor>
                <product>${monitors.monitorspec.product}</product>
                <serial>${monitors.monitorspec.serial}</serial>
              </monitorspec>
              <mode>
                <width>${builtins.toString monitors.mode.width}</width>
                <height>${builtins.toString monitors.mode.height}</height>
                <rate>${builtins.toString monitors.mode.rate}</rate>
              </mode>
              <colormode>bt${builtins.toString monitors.HDR}</colormode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    '';
  };
}
