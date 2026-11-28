{
  flake.aspects."security".darwin = {
    security.pam.services.sudo_local = {
      # Add ability to use Touch ID for sudo authentication.
      touchIdAuth = true;
      # Keep Touch ID authentication working inside tmux and screen.
      reattach = true;
      # Allow Apple Watch authentication when configured in macOS.
      watchIdAuth = true;
    };
  };

}
