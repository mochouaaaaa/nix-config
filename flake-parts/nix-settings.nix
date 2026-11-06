{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      lib,
      system,
      ...
    }:

    let
      isDarwinIntel = system == "x86_64-darwin";

      nixpkgsInput = if isDarwinIntel then inputs.nixpkgs-darwin else inputs.nixpkgs;

      nixPkgs =
        if isDarwinIntel then inputs'.nixpkgs-darwin.legacyPackages else inputs'.nixpkgs.legacyPackages;

      isLix = lib.hasAttr "lixPackageSets" nixPkgs;
    in
    {
      _module.args.nix = {
        nixPath = [
          "nixpkgs=${nixpkgsInput}"
        ];

        package = if isLix then lib.mkForce nixPkgs.lixPackageSets.stable.lix else nixPkgs.nix;

        registry.nixpkgs.to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = nixpkgsInput.rev;
        };

        channel.enable = false;

        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        }
        // lib.mkIf nixPkgs.stdenv.hostPlatform.isLinux {
          dates = "weekly";
        };

        settings = lib.mkMerge [
          (lib.mkIf isLix {
            experimental-features = lib.mkForce [
              "flakes"
              "nix-command"
              "auto-allocate-uids"
            ];
          })

          {
            keep-outputs = true;
            keep-derivations = true;
            keep-going = true;
            builders-use-substitutes = true;
            allow-unsafe-native-code-during-evaluation = true;
            accept-flake-config = true;
            http-connections = 0;
            use-xdg-base-directories = true;
            auto-optimise-store = true;
            max-jobs = "auto";

            experimental-features = lib.mkDefault [
              "flakes"
              "nix-command"
              "auto-allocate-uids"
              "pipe-operators"
              "ca-derivations"
              "dynamic-derivations"
            ];
            extra-deprecated-features = [
              "or-as-identifier"
              "broken-string-indentation"
            ];

            trusted-substituters = [
              "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
              "https://cache.nixos.org?priority=12"
              "https://nix-community.cachix.org?priority=13"
              "https://mochouaaaaa.cachix.org"
            ];

            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
            ];

          }

          (lib.mkIf (nixPkgs.stdenv.hostPlatform.isDarwin && nixPkgs.stdenv.isAarch64) {
            extra-platforms = "x86_64-darwin";
          })

          (lib.mkIf nixPkgs.stdenv.hostPlatform.isDarwin {
            sandbox = "relaxed";
          })
        ];
      };
    };
}
