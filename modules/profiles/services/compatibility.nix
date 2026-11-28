{
  flake.aspects = { aspects, ... }: {
    "services.virtualisation.orbstack" = {
      includes = [ aspects.services._.virtualisation._.orbstack ];
      darwin = _: { };
    };

    services-dns-mosdns = {
      includes = [ aspects.services._.dns._.mosdns ];
      nixos = _: { };
    };

    services-avahi = {
      includes = [ aspects.services._.avahi ];
      nixos = _: { };
    };

    services-console = {
      includes = [ aspects.services._.console ];
      nixos = _: { };
    };

    services-brightness = {
      includes = [ aspects.services._.brightness ];
      nixos = _: { };
    };

    services-uptermd = {
      includes = [ aspects.services._.uptermd ];
      nixos = _: { };
    };

    services-proxy = {
      includes = [ aspects.services._.proxy ];
      nixos = _: { };
    };

    services-ollama = {
      includes = [ aspects.services._.ollama ];
      nixos = _: { };
    };
  };
}
