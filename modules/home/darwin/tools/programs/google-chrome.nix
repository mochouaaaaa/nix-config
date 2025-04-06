{ pkgs, config, ... }:
let
  cfg = config.modules.packages.google-chrome;
in
{
  programs = {
    chromium = {
      package = pkgs.google-chrome;
      enable = cfg.enable;
      extensions = cfg.extensions;
    };
  };
}
