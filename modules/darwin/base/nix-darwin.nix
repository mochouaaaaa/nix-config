{ lib, ... }:
{
  system = {
    tools = {
      darwin-option.enable = true;
      darwin-rebuild.enable = true;
      darwin-uninstaller.enable = true;
      darwin-version.enable = true;
    };
  };

  services.nix-daemon.enableSocketListener = true;

  documentation = rec {
    enable = false;
    doc.enable = enable;
    info.enable = enable;
    man.enable = enable;
  };
}
