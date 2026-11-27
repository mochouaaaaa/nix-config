{ self, ... }:
{
  flake.aspects = { aspects, ... }: {
    "desktop.hardware" = {
      includes = [
        aspects."hardware.desktop"
        {
          nixos.imports = [
            self.modules.nixos.hardware
          ];
        }
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
