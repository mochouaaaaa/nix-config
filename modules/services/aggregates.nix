{
  flake.aspects = { aspects, ... }: {
    "services.virtualisation.vm" = {
      includes = [ aspects.services._.virtualisation.vm ];
      nixos = { ... }: { };
    };

    "services.virtualisation.podman" = {
      includes = [ aspects.services._.virtualisation.podman ];
      nixos = { ... }: { };
    };

    "services.virtualisation.qemu" = {
      includes = [ aspects.services._.virtualisation.qemu ];
      nixos = { ... }: { };
    };

    "services.virtualisation.orbstack" = {
      includes = [ aspects.services._.virtualisation.orbstack ];
      darwin = { ... }: { };
    };

    "services.dns.mosdns" = {
      includes = [ aspects.services._.dns.mosdns ];
      nixos = { ... }: { };
    };

    "services.avahi" = {
      includes = [ aspects.services._.avahi ];
      nixos = { ... }: { };
    };

    "services.console" = {
      includes = [ aspects.services._.console ];
      nixos = { ... }: { };
    };

    "services.brightness" = {
      includes = [ aspects.services._.brightness ];
      nixos = { ... }: { };
    };

    "services.uptermd" = {
      includes = [ aspects.services._.uptermd ];
      nixos = { ... }: { };
    };

    "services.proxy" = {
      includes = [ aspects.services._.proxy ];
      nixos = { ... }: { };
    };

    "services.ollama" = {
      includes = [ aspects.services._.ollama ];
      nixos = { ... }: { };
    };
  };
}
