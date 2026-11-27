{ self, ... }:
{
  flake.aspects = { ... }: {
    "desktop.hardware" = {
      # These modules have not been migrated to aspects yet; keep them as
      # an inline dependency until their owning modules are converted.
      includes = [
        {
          nixos.imports = [
            self.modules.nixos.hardware
            self.modules.nixos."hardware.desktop"
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
