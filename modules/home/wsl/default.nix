{ lib, self, ... }:
{
  imports = lib.importModule' ./. ++ [
    self.homeModules.linux.modules
  ];

  options.programs.wsl.enable = lib.mkEnableOption "automatic VSCode remote server patch";

  config = {

    services.xremap.enable = lib.mkForce false;

    dconf.enable = lib.mkForce false;

    services = {
      flatpak.enable = lib.mkForce false;
      udiskie.enable = lib.mkForce true;
      syncthing.enable = lib.mkForce false;
    };

    programs = {
      vscode.enable = lib.mkForce false;
      nh = {
        enable = lib.mkForce false;
        clean.enable = lib.mkForce false;
      };
    };

    i18n.inputMethod = {
      enable = lib.mkForce false;
    };
  };
}
