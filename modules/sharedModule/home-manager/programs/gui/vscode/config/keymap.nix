{
  pkgs,
  ...
}:
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
              (buildVscodeMarketplaceExtension {
                mktplcRef = {
                  name = "yazi-vscode";
                  publisher = "dautroc";
                  version = "1.0.10";
                  hash = "sha256-o1zsV6pz7+/kNMBtCqXWkxS+/HCQOfrnifpyPeKrwTk=";
                };
              })

            ];
          keybindings = [
            {
              key = "meta+r";
              command = "yazi-vscode.toggle";
            }
            {
              key = "ctrl+shift+y";
              command = "-yazi-vscode.toggle";
            }
          ];

        };
      };
    };
  };
}
