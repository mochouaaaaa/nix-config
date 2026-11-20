{ inputs, ... }:
{
  flake.modules.homeManager."desktop.kde" = {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];
  };
}
