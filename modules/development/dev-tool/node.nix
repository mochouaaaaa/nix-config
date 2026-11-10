{
  flake.modules.homeManager.development = { pkgs, config, ... }: {

    home.packages = [
      # pkgs.nodejs
      # pkgs.antigravity-cli
    ];
    # ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux) [
    #   pkgs.antigravity-cli
    # ]
    # ++ (lib.optionals pkgs.stdenv.hostPlatform.isDarwin) [
    #   pkgs.gemini-cli
    # ];

    # programs = {
    #   npm = {
    #     enable = true;
    #     package = pkgs.nodejs;
    #     settings = {
    #       color = true;
    #       include = [
    #         "dev"
    #         "prod"
    #       ];
    #       init-license = "MIT";
    #       prefix = "${config.home.homeDirectory}/.npm";
    #     };
    #   };
    # };

  };

  flake.modules.nixos.preservation = { username, ... }: {
    profiles.preservation.users.${username}.directories = [
      ".npm"
      ".yarn"
    ];
  };

}
