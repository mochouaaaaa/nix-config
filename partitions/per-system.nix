{
  imports = [
    ../modules/flake/packages.nix
    ../modules/flake/apps.nix
    ../modules/flake/deploy-per-system.nix
    ../modules/flake/devshells.nix
    ../modules/flake/formatter.nix
    ../modules/flake/checks.nix
    ../modules/security/agenix/config.nix
  ];
}
