{ config, inputs, lib, ... }:
{
  flake.aspects =
    { aspects, ... }:
    let
      flakeAspectsLib = inputs.flake-aspects.lib inputs.nixpkgs.lib;

      forwardHomeManager =
        {
          username,
          intoClass,
          roles,
        }:
        flakeAspectsLib.forward {
          each = roles;
          fromClass = _: "homeManager";
          intoClass = _: intoClass;
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
          hostProfiles.${host.hostName}
            or (throw "Host '${host.username}@${host.hostName}' has no Host Profile.");

        # Agenix Home Manager secrets are enabled only on the NixOS host
        # that also imports the corresponding NixOS agenix module.
        roles =
          profile.roles
          ++ lib.optionals (host.hostName == "nixos") [ aspects.agenix ];
      in
      lib.nameValuePair "host.${host.username}.${host.hostName}" {
        includes = [
          (forwardHomeManager {
            inherit (host) username;
            intoClass = profile.class;
            inherit roles;
          })
        ] ++ lib.optionals (host.hostName == "nixos") [
          aspects.editors._.neovim._.preservation
        ];

        ${profile.class} = { ... }: { };
      }
    ) config.hosts;
}
