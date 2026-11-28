{
  flake.aspects = { aspects, ... }: {
    desktop-programs.provides.configured =
      {
        browsers,
        security,
        communication,
        email,
        databases,
        networking,
      }:
      {
        includes = [
          aspects.desktop-api-clients
          (aspects.desktop-browsers { inherit browsers; })
          aspects.desktop-audio
          (aspects.desktop-security { inherit security; })
          (aspects.desktop-communication { inherit communication; })
          (aspects.desktop-email { inherit email; })
          aspects.desktop-media
          aspects.desktop-notes
          aspects.desktop-remote
          aspects.desktop-office
          (aspects.desktop-database { inherit databases; })
          (aspects.desktop-networking { inherit networking; })
        ];

        nixos = _: { };
        homeManager = _: { };
      };
  };
}
