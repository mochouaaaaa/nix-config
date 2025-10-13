{ lib, pkgs, ... }:
let
  overpkgs = pkgs.wshowkeys.overrideAttrs (finalAttrs: {
    pname = "wshowkeys-last";

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

  programs.wshowkeys = rec {
    enable = true;
    package = overpkgs;
  };

  environment.systemPackages =
    let
      wshowkeysDesktop = pkgs.makeDesktopItem {
        name = "wshowkeys";
        desktopName = "WShowKeys";
        comment = "Show input keys on screen";
        exec = "${lib.getExe overpkgs} -a bottom -a right";
        # icon = "input-keyboard"; # 可以放图标名称或绝对路径
        categories = [ "Utility" ];
        terminal = false; # 如果命令需要在终端执行改成 true
      };
    in
    [
      wshowkeysDesktop
    ];
}
