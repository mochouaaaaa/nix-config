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
            # "intellij-idea-keybindings.useCamelHumpsWords" = true;
          };
          extensions =
            let
              inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            in
            [
              # (buildVscodeMarketplaceExtension {
              #   mktplcRef = {
              #     name = "intellij-idea-keybindings";
              #     publisher = "k--kato";
              #     version = "1.7.5";
              #     hash = "sha256-DOSe0UhNMj6FRyHylnKYQsyhSLQQFvGfcmOBZSw+nVo=";
              #   };
              # })
            ];

          keybindings = [
            {
              key = "meta+f";
              command = "find-it-faster.findFiles";
            }
            {
              key = "meta+shift+f";
              command = "find-it-faster.findWithinFiles";
            }
          ];
        };
      };
    };
  };
}
