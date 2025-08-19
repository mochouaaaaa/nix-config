{
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = lib.importModule' ./.;

  options.modules'.packages.vscode = with lib; {
    commandLineArgs = mkOption rec {
      type = types.listOf types.str;
      default = [
        "--locale=zh-cn"
        "--no-sandbox"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
        "--gtk-version=4"
      ];
      description = "Additional command line arguments to pass to the VSCode binary.";
      apply = userValue: default ++ userValue;
    };
  };

  config = {

    programs = {
      vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles = {
          "${username}" = {
            extensions = with pkgs.vscode-extensions; [
              ms-ceintl.vscode-language-pack-zh-hans
              usernamehw.errorlens
              eamodio.gitlens
              mhutchie.git-graph
              vspacecode.whichkey

              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vscode-remote.vscode-remote-extensionpack
            ];
          };
        };
      };
    };

  };
}
