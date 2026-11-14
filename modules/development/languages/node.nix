{
  # Node.js is part of the shared development language toolchain.
  flake.modules.homeManager.development = { self, ... }: {
    imports = [ self.modules.homeManager."development.node" ];
  };

  flake.modules.homeManager."development.node" =
    { lib, pkgs, config, ... }:
    {
      # npm owns the Node.js package as well as the user-level npmrc.
      # Use one Node.js version for both the runtime and npm CLI.
      programs.npm = {
        enable = true;
        package = pkgs.nodejs;
        settings = {
          color = true;
          include = [
            "dev"
            "prod"
          ];
          init-license = "MIT";
          prefix = "${config.home.homeDirectory}/.npm";
        };
      };

      home.packages = [ pkgs.yarn ];
    };

  # Preserve global package-manager state only when installed through Home Manager.
  # Project-local Node.js runtimes are intentionally not inferred here.
  flake.modules.nixos.preservation =
    {
      lib,
      pkgs,
      config,
      username,
      ...
    }:
    let
      homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in
    {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.nodejs homePackages) [ ".npm" ]
        ++ lib.optionals (lib.elem pkgs.yarn homePackages) [ ".yarn" ];
    };
}
