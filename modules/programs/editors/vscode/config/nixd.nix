let
  mkNixdConfig =
    {
      configuration,
      systemOptionName,
    }:
    {
      lib,
      pkgs,
      username,
      hostName,
      ...
    }:
    let
      flakeExpr = "(builtins.getFlake (builtins.toString ./.)).";
      hostExpr = "${flakeExpr}${configuration}.\"${username}@${hostName}\"";
      optionsExpr = "${hostExpr}.options";
    in
    {
      programs.vscode.profiles.default.userSettings."nix.serverSettings".nixd = {
        nixpkgs.expr = "${hostExpr}.pkgs";
        formatting.command = [ (lib.getExe pkgs.nixfmt) ];
        options = {
          "${systemOptionName}".expr = optionsExpr;
          "home-manager".expr = "${optionsExpr}.home-manager.users.type.getSubOptions []";
        };
      };
    };
in
{
  # Keep nixd available even when Neovim is disabled.
  flake.modules.homeManager."programs.vscode" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nixd
        pkgs.nixfmt
      ];
    };

  # Platform modules provide the matching flake output and option namespace.
  flake.modules.homeManager.darwin = mkNixdConfig {
    configuration = "darwinConfigurations";
    systemOptionName = "nix-darwin";
  };

  flake.modules.homeManager.linux = mkNixdConfig {
    configuration = "nixosConfigurations";
    systemOptionName = "nixos";
  };
}
