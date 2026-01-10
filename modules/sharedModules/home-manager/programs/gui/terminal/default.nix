{ lib, pkgs, ... }:
let

  kitty-icon = pkgs.fetchFromGitHub {
    owner = "DinkDonk";
    repo = "kitty-icon";
    rev = "main";
    hash = "sha256-f+uiesvd0Vdoef6X2kqmbd+4CX2TXdkUGwZdzaKg5bY=";
  };

in
{

  options.profiles.packages.terminal = {
    kitty = with lib; {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable kitty.";
      };
      extraConfig = mkOption rec {
        type = types.listOf types.str;
        default = [ ];
        description = "Extra configuration lines for kitty.conf.";
        apply = userValue: default ++ userValue;
      };
      icon = mkOption {
        type = types.path;
        default = kitty-icon;
      };
    };

    wezterm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable wezterm.";
      };
    };

    foot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable foot.";
      };
    };

  };

}
