{ ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.hardware" = {
      includes = [
        aspects.hardware
        aspects.hardware.desktop
      ];

      nixos =
        { username, ... }:
        {
          # These device groups are only needed by the graphical host.
          users.groups.uinput = { };
          users.users.${username}.extraGroups = [
            "input"
            "uinput"
            "video"
          ];
        };
    };
  };
}
