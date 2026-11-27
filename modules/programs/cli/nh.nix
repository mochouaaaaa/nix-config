{
  flake.aspects."programs"."homeManager" = { config, ... }: {
    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nix";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
  };
}
