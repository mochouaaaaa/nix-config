{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.user" = {
      includes = [
        aspects."desktop.launcher.vicinae"
        aspects.rime
        aspects.shortcuts
      ];

      homeManager =
        { pkgs, myvars, ... }:
        {
          home.file =
            let
              face = pkgs.fetchurl {
                url = "https://github.com/${myvars.githubUsername}.png";
                hash = "sha256-xNnccpACVHCXLHs7rWYLdyAKGSbRcG2/u1U4PDECKbw=";
              };
            in
            {
              ".face".source = face;
            };
        };
    };
  };
}
