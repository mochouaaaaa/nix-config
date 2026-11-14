{
  flake.modules.homeManager.linux =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.vscode = {
        package = lib.mkDefault pkgs.vscode-fhs;

        profiles.default = {
          userSettings = {
            "vscode-default-keybindings.removeOSKeybindings" = true;
            "vscode-default-keybindings.macOSKeybindings" = true;
            "qt-qml.doNotAskForQmllsDownload" = true;
            "qt-qml.qmlls.customExePath" = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
          };
          extensions = [
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "vscode-default-keybindings";
                publisher = "jbro";
                version = "0.2.51";
                hash = "sha256-SJ+YghLJMWqvNsvhMLLzyPgkAiy/g+WlobXBx0mUGLs=";
              };
            })
            (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "qt-qml";
                publisher = "TheQtCompany";
                version = "1.7.0";
                hash = "sha256-QjfvZIcE4LcJU93YiYN/zykEluHtR7zVOwYiPL0k+cQ=";
              };
              meta.license = lib.licenses.gpl3Plus;
            })
          ];
        };
      };

      xdg.mimeApps.defaultApplicationPackages =
        lib.optionals (config.programs.vscode.package != null) [
          config.programs.vscode.package
        ];
    };

  flake.modules.homeManager.wsl =
    { self, ... }:
    {
      imports = [
        self.modules.homeManager."programs.vscode"
        self.modules.homeManager.linux
      ];

      programs.vscode.package = null;
    };

  flake.modules.nixos.preservation =
    {
      lib,
      config,
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals config.home-manager.users.${username}.programs.vscode.enable
          [
            # vscode
            ".vscode"
            ".config/Code"
            ".vscode-insiders" # open source
            ".config/Code - Insiders"
          ];
    };

}
