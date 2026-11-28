{
  flake.aspects.desktop-cosmic.homeManager = { inputs, ... }: {

    imports = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];

    wayland.desktopManager.cosmic.enable = true;
    programs = {
      cosmic-edit = {
        enable = false;
      };
    };

  };
}
