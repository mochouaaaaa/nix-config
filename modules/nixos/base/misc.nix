{
  lib,
  config,
  pkgs,
  ...
}:
let
  isWsl = config.profiles.wsl.enable;
in
{
  # set user's default shell system-wide
  users.defaultUserShell = pkgs.zsh;

  # fix for `sudo xxx` in kitty/wezterm and other modern terminal emulators
  security.sudo = {
    keepTerminfo = true;
    execWheelOnly = true;
  };

  environment.variables = {
    # fix https://github.com/NixOS/nixpkgs/issues/238025
    TZ = "${config.time.timeZone}";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    lib.optionals (!isWsl) [
      ntfs3g
    ];

  services = {
    envfs.enable = true;
  }
  // lib.mkIf (!isWsl) {
    resolved.enable = true; # DNS resolver
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  programs = {
    # dconf is a low-level configuration system.
    dconf.enable = !isWsl;
  };
}
