{ self, ... }:
{
  flake.modules.nixos."desktop.hardware" =
    { username, ... }:
    {
      imports = [
        self.modules.nixos.hardware
        self.modules.nixos."hardware.desktop"
      ];

      # These device groups are only needed by the graphical host.
      users.groups.uinput = { };
      users.users.${username}.extraGroups = [
        "input"
        "uinput"
        "video"
      ];
    };
}
