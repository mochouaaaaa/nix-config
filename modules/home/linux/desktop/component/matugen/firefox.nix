{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.programs.firefox;
  cfgMatugen = config.programs.matugen;
  cfgNoctalia = config.programs.noctalia-shell;
in
{
  config = lib.mkIf (cfg.enable && cfgMatugen.enable) (
    lib.mkMerge [

      {
        home.packages = [
          pkgs.pywalfox-native
        ];

        programs.firefox.profiles."${username}".extensions = {
          packages = [
            pkgs.nur.repos.rycee.firefox-addons.pywalfox
          ];
        };
      }

    ]
  );

}
