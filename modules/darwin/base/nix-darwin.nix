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
}
