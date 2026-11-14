{
  # Antigravity CLI is an AI coding agent, not part of the Node.js toolchain.
  flake.modules.homeManager."agents.antigravity" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.antigravity-cli ];
    };
}
