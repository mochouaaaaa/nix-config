{
  # Gemini CLI is an AI coding agent, not part of the Node.js toolchain.
  flake.modules.homeManager."agents.gemini" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gemini-cli ];
    };
}
