{
  flake.modules.darwin.security = {
    security.pam.services.sudo_local = {
      # Add ability to use Touch ID for sudo authentication.
      touchIdAuth = true;
      # Keep Touch ID authentication working inside tmux and screen.
      reattach = true;
      # Allow Apple Watch authentication when configured in macOS.
      watchIdAuth = true;
    };
  };

  flake.modules.darwin."system.defaults" =
    { username, ... }:
    {
      system.primaryUser = username;

      system.defaults = {
        menuExtraClock.Show24Hour = true;
        NSGlobalDomain = {
          "com.apple.sound.beep.volume" = 0.0;
          "com.apple.sound.beep.feedback" = 0;
        };
      };
    };
}
