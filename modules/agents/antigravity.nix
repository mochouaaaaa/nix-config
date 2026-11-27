{
  # Antigravity CLI is an AI coding agent; delegate installation and configuration
  # to Home Manager's native program module.
  flake.aspects."agents.antigravity".homeManager = {
    programs = {
      # antigravity-ide = {
      #   enable = true;
      # };
      antigravity-cli = {
        enable = true;
        mutableSettings = true;
      };
    };
  };

  flake.aspects.preservation.nixos =
    {
      username,
      lib,
      config,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories =
        lib.optional config.home-manager.users.${username}.programs.antigravity-cli.enable
          ".antigravity-ide";
    };

}
