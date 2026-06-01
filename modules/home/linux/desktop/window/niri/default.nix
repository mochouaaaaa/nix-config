{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.desktop.niri;
in
{
  imports = [ inputs.niri.homeModules.niri ];

  config = lib.mkIf cfg.enable {

    nix.settings = {
      trusted-substituters = [ "https://niri.cachix.org" ];
      trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

  };
}
