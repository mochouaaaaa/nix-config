{ inputs, ... }:
{
  flake.aspects = { aspects, ... }:
    let
      forwardHomeManager =
        intoClass: roles:
        inputs.flake-aspects.lib.forward {
          each = roles;
          fromClass = _: "homeManager";
          inherit intoClass;
          intoPath = _: [
            "home-manager"
            "users"
            "mochou"
          ];
          fromAspect = aspect: aspect;
        };
    in
    {
      # NixOS desktop host: the host role owns Home Manager role selection.
      "host.mochou.nixos" = {
        includes = [
          (forwardHomeManager "nixos" [
            aspects.host
            aspects.workstation
            aspects.linux
            aspects."development.gui"
            aspects."agents.codex"
            aspects."agents.antigravity"
            aspects."desktop.programs"
          ])
        ];
        nixos = { ... }: { };
      };

      "host.mochou.darwin" = {
        includes = [
          (forwardHomeManager "darwin" [
            aspects.host
            aspects.workstation
            aspects."desktop.programs.api-clients"
            aspects."desktop.programs.browsers"
            aspects.darwin
            aspects."agents.codex"
          ])
        ];
        darwin = { ... }: { };
      };

      "host.mochou.wsl" = {
        includes = [
          (forwardHomeManager "nixos" [
            aspects.host
            aspects.linux
            aspects.wsl
            aspects.servers
          ])
        ];
        nixos = { ... }: { };
      };

      "host.mochou.remote" = {
        includes = [
          (forwardHomeManager "nixos" [
            aspects.host
            aspects.servers
          ])
        ];
        nixos = { ... }: { };
      };
    };
}
