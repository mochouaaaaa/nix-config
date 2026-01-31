{
  pkgs,
  lib,
  config,
  username,
  myvars,
  ...
}:
{
  # Don't allow mutation of users outside the config.
  users.mutableUsers = false;
  hardware.enableAllFirmware = true;
  hardware.uinput.enable = true;
  users.groups = {
    "${username}" = { };
    docker = { };
    wireshark = { };
    # for android platform tools's udev rules
    adbusers = { };
    dialout = { };
    # for openocd (embedded system development)
    plugdev = { };
    # misc
    uinput = { };
  };

  services.userborn = {
    enable = true;
    passwordFilesLocation = "/var/lib/nixos";
  };

  users.users."${username}" = {
    inherit (myvars) initialHashedPassword;

    home = "/home/${username}";
    isNormalUser = true;
    extraGroups = [
      username
      "users"
      "networkmanager"
      "wheel"
      "wireshark"
      "adbusers"
      "libvirtd"
      "input"
      "uinput"
      "video"
      "plugdev"
    ];
  };

  # root's ssh key are mainly used for remote deployment
  users.users.root = {
    inherit (myvars) initialHashedPassword;
    openssh.authorizedKeys.keys = config.users.users."${username}".openssh.authorizedKeys.keys;
  };

  environment.etc =
    let
      autosubs = lib.pipe config.users.users [
        lib.attrValues
        (lib.filter (u: u.uid != null && u.isNormalUser))
        (lib.concatMapStrings (u: "${toString u.uid}:${toString (100000 + u.uid * 65536)}:65536\n"))
      ];
    in
    lib.optionalAttrs (config.services.userborn.enable) {
      "subuid" = {
        text = autosubs;
        mode = "0444";
      };
      "subgid" = {
        text = autosubs;
        mode = "0444";
      };
    };

}
