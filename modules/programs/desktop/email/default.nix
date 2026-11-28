{
  flake.aspects = { aspects, ... }: {
    desktop-email = { email }: {
      includes = [ aspects.desktop-programs._.email._.${email} ];
      nixos = _: { };
      homeManager = _: { };
    };
  };
}
