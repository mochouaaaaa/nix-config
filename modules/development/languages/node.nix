{
  # Preserve global package-manager state only when installed through Home Manager.
  # Project-local Node.js runtimes are intentionally not inferred here.
  flake.modules.nixos.preservation = { lib, pkgs, config, username, ... }:
    let homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.nodejs homePackages) [ ".npm" ]
        ++ lib.optionals (lib.elem pkgs.yarn homePackages) [ ".yarn" ];
    };
}
