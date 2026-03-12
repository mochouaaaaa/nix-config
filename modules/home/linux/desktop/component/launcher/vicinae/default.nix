{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.services.vicinae;
in
{
  imports = [ inputs.vicinae.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    nix.settings = {
      trusted-substituters = [ "https://vicinae.cachix.org" ];
      trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
    };
  };
}
