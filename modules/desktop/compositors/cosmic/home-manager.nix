{
  flake.modules.homeManager."desktop.cosmic" = { inputs, ... }: {

    imports = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];

    wayland.desktopManager.cosmic.enable = true;
    programs = {
      cosmic-edit = {
        enable = false;
      };
    };

  };
}
