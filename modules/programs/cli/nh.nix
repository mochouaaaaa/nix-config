{
  flake.modules.homeManager.programs = { config, ... }: {

    programs.nh = rec {
      enable = true;
      flake = "${config.home.homeDirectory}/nix";
      clean = {
        inherit enable;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 5";
      };
    };

  };
}
