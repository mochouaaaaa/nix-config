{
  flake.aspects.security.provides.sudo.nixos = {
    security = {
      # fix for `sudo xxx` in kitty/wezterm and other modern terminal emulators
      sudo = {
        keepTerminfo = true;
        execWheelOnly = true;
      };
    };
  };
}
