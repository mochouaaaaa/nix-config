{
  # Preserve package-manager state on impermanent systems.
  # The Node.js runtime is selected per project rather than globally.
  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".npm"
      ".yarn"
    ];
  };
}
