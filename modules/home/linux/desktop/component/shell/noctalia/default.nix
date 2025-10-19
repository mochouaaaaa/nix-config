{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfgNoctalia = config.modules'.desktop.shell.noctalia;
in
{

  imports = lib.importModule' ./. ++ [
    inputs.noctalia.homeModules.default
  ];

  options.modules'.desktop.shell.noctalia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia's Noctalia Shell module";
    };
  };

  config = lib.mkIf (cfgNoctalia.enable) {

    home.packages = [ inputs.noctalia.packages.${pkgs.system}.default ];

    services.cliphist.enable = lib.mkForce false;
    services.darkman.enable = lib.mkForce false;

    systemd.user.services = {
      noctalia-shell = {
        Unit = {
          Description = "Noctalia Shell";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
          # X-Restart-Triggers = [ "${config.home.stateDir}/noctalia-shell.pid" ];
        };

        Service = {
          Type = "exec";
          ExecStart = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStartSec = "5s";
          Environment = [
            "QT_QPA_PLATFORM=wayland"
            "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
          ];
          Slice = "session.slice";
        };
        Install = {
          WantedBy = [ config.wayland.systemd.target ];
        };
      };
    };

    programs.noctalia-shell = {
      enable = true;
      # this may also be a string or a path to a JSON file,
      # but in this case must include *all* settings.
    };

  };

}
