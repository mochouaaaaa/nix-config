{
  flake.aspects = { aspects, ... }: {
    "desktop.kde" = {
      includes = [
        aspects."desktop.default-apps"
      ];

      homeManager = { inputs, ... }: {
        imports = [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
      };
    };
  };
}
