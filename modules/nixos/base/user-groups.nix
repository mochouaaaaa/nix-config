{
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
}
