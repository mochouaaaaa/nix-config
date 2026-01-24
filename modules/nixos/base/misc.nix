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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = lib.optionals (!isWsl) [
    pkgs.ntfs3g
  ];

  programs = {
    # dconf is a low-level configuration system.
    dconf.enable = !isWsl;
  };
}
