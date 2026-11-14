{
  # Antigravity CLI is an AI coding agent; delegate installation and configuration
  # to Home Manager's native program module.
  flake.modules.homeManager."agents.antigravity" = {
    programs.antigravity-cli.enable = true;
  };
}
