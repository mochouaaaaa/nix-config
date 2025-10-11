{ lib, pkgs, ... }:
{
  imports = lib.importModule' ./.;

  programs.wshowkeys = rec {
    enable = true;
    package = pkgs.wshowkeys.overrideAttrs (finalAttrs: {
      pname = "wshowkeys-last";

      src = pkgs.fetchFromGitHub {
        owner = "ammgws";
        repo = "wshowkeys";
        tag = "0.1";
        hash = "sha256-/HvNCQWsXOJZeCxHWmsLlbBDhBzF7XP/SPLdDiWMDC4=";
      };
    });
  };
}
