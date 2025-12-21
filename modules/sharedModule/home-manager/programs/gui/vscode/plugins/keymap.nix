{
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.modules'.keymaps;
in
{
  programs = {
    vscode = {
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles = {
        default = {
          userSettings = {
          };
          extensions =
            let
              inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            in
            [

            ];

        };
      };
    };
  };
}
