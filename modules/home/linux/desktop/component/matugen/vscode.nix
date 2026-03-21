{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.vscode;
  cfgMatugen = config.programs.matugen;
  cfgNoctalia = config.programs.noctalia-shell;

in
{
  config = lib.mkIf (cfg.enable && cfgMatugen.enable) (
    lib.mkMerge [

      (lib.mkIf cfgNoctalia.enable {
        programs.vscode.profiles.default = {
          userSettings = {
            "workbench.colorTheme" = lib.mkForce "NoctaliaTheme";
            "workbench.preferredLightColorTheme" = lib.mkForce "NoctaliaTheme";
            "workbench.preferredDarkColorTheme" = lib.mkForce "NoctaliaTheme";
          };
          extensions =
            let
              inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            in
            [
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "noctaliatheme";
              #     publisher = "Noctalia";
              #     version = "0.0.5";
              #     hash = "sha256-aTSk3yYkBw5GrD0CbRL2wo3SlBffzBTDe1pZoZa1URQ=";
              #   };
              # })
            ];
        };

      })

    ]
  );
}
