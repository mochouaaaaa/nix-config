{ config, inputs, lib, ... }:
{
  flake.aspects =
    { aspects, ... }:
    let
      forwardHomeManager =
        {
          username,
          intoClass,
          roles,
        }:
        inputs.flake-aspects.lib.forward {
          each = roles;
          fromClass = _: "homeManager";
          inherit intoClass;
          intoPath = _: [
            "home-manager"
            "users"
            username
          ];
          fromAspect = aspect: aspect;
        };

      # Host names identify the machine role; usernames come from Host metadata.
      hostProfiles = {
        nixos = {
          class = "nixos";
          roles = [
            aspects.host
            aspects.workstation
            aspects.linux
            aspects."development.gui"
            aspects."agents.codex"
            aspects."agents.antigravity"
            aspects."desktop.programs"
          ];
        };

        darwin = {
          class = "darwin";
          roles = [
            aspects.host
            aspects.workstation
            aspects."desktop.programs.api-clients"
            aspects."desktop.programs.browsers"
            aspects.darwin
            aspects."agents.codex"
          ];
        };

        wsl = {
          class = "nixos";
          roles = [
            aspects.host
            aspects.linux
            aspects.wsl
            aspects.servers
          ];
        };

        remote = {
          class = "nixos";
          roles = [
            aspects.host
            aspects.servers
          ];
        };
      };
    in
    lib.mapAttrs' (
      _name: host:
      let
        profile =
          hostProfiles.\${host.hostName}
            or (throw "Host '\${host.username}@\${host.hostName}' has no Host Profile.");
      in
      lib.nameValuePair "host.\${host.hostName}" {
        includes = [
          (forwardHomeManager {
            inherit (host) username;
            inherit (profile) class roles;
          })
        ];

        \${profile.class} = { ... }: { };
      }
    ) config.hosts;
}
