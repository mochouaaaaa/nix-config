{
  # Shared Linux and WSL VS Code settings and extensions.
  flake.aspects."programs.vscode.linux-config"."homeManager" =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.vscode.profiles.default = {
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

  flake.aspects."linux"."homeManager" =
    {
      self,
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [ self.modules.homeManager."programs.vscode.linux-config" ];

      programs.vscode.package = lib.mkDefault pkgs.vscode-fhs;

      xdg.mimeApps.defaultApplicationPackages = lib.optional (
        config.programs.vscode.package != null
      ) config.programs.vscode.package;
    };

  flake.aspects."wsl"."homeManager" =
    { self, ... }:
    {
      imports = [
        self.modules.homeManager."programs.vscode"
        self.modules.homeManager."programs.vscode.linux-config"
      ];

      programs.vscode.package = null;
    };

  flake.aspects."preservation"."nixos" =
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
