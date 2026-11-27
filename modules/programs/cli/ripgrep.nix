{
  flake.aspects."programs"."homeManager" = { pkgs, ... }: {

    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override { withPCRE2 = true; };
    };

  };
}
