{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.modules'.desktop.services.cliphist;
in
{
  options.modules'.desktop.services.cliphist = {
    enable = lib.mkEnableOption "ClipHist daemon";
  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.cliphist = {
      Unit = {
        Description = "Cliphist store (text + image)";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "exec";
        ExecStart =
          let
            shell = pkgs.writeShellScriptBin "cliphist-store" ''
              ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
              ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
               trap "kill 0" EXIT
               wait -n
            '';
          in
          "${lib.getExe shell}";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}
