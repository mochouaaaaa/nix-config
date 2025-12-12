{
  lib,
  pkgs,
  config,
  ...
}:
let
  overpkgs = pkgs.wshowkeys.overrideAttrs (finalAttrs: {
    pname = "wshowkeys";
    version = "last";

    src = pkgs.fetchFromGitHub {
      owner = "ammgws";
      repo = "wshowkeys";
      tag = "0.1";
      hash = "sha256-/HvNCQWsXOJZeCxHWmsLlbBDhBzF7XP/SPLdDiWMDC4=";
    };
  });
in
{
  imports = lib.importModule' ./.;

  config = lib.mkIf (config.programs.desktop.enable) {

    environment.systemPackages =
      let
        wshowkeysBin = "${config.security.wrapperDir}/wshowkeys";
        toggleScript = pkgs.writeShellScriptBin "toggle-wshowkeys" ''
          if pgrep -x "wshowkeys" > /dev/null; then
            pkill -x "wshowkeys"
          else
            ${wshowkeysBin} -a bottom -a right &
          fi
        '';
        wshowkeysDesktop = pkgs.makeDesktopItem {
          name = "wshowkeys";
          desktopName = "WShowKeys";
          comment = "Show input keys on screen";
          exec = "${lib.getExe toggleScript}";
          categories = [ "Utility" ];
          terminal = false;
        };
      in
      [
        wshowkeysDesktop
      ];

    security.wrappers.wshowkeys = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe overpkgs;
    };

  };
}
