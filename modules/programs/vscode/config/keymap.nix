{
  flake.modules.homeManager.programs-vscode = { pkgs, ... }: {

    programs = {
      vscode = {
        # let vscode sync and update its configuration & extensions across devices, using github account.
        profiles = {
          default = {
            # userSettings = {
            #   "workbench.preferredLightColorTheme" = "NoctaliaTheme";
            # };
            # extensions =
            #   let
            #     inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
            #   in
            #   [
            #     (buildVscodeMarketplaceExtension {
            #       mktplcRef = {
            #         name = "noctaliatheme";
            #         publisher = "Noctalia";
            #         version = "0.0.5";
            #         hash = "sha256-aTSk3yYkBw5GrD0CbRL2wo3SlBffzBTDe1pZoZa1URQ=";
            #       };
            #     })
            #   ];
            # keybindings = [
            #   {
            #     key = "meta+r";
            #     command = "yazi-vscode.toggle";
            #   }
            #   {
            #     key = "ctrl+shift+y";
            #     command = "-yazi-vscode.toggle";
            #   }
            # ];

          };
        };
      };
    };

  };
}
