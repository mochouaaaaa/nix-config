{ inputs, lib, ... }:

let
  cacheSettings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://mochouaaaaa.cachix.org"
    ];

    trusted-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://mochouaaaaa.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
    ];
  };

  commonSettings = pkgs: {
    keep-outputs = true;
    keep-derivations = true;
    keep-going = true;
    builders-use-substitutes = true;
    accept-flake-config = true;
    http-connections = 0;
    use-xdg-base-directories = true;
    auto-optimise-store = true;
    max-jobs = "auto";

    experimental-features =
      if pkgs ? lixPackageSets then
        lib.mkForce [
          "flakes"
          "nix-command"
          "auto-allocate-uids"
        ]
      else
        lib.mkDefault [
          "flakes"
          "nix-command"
          "auto-allocate-uids"
          "pipe-operators"
          "ca-derivations"
          "dynamic-derivations"
        ];

    # extra-deprecated-features = [
    #   "or-as-identifier"
    #   "broken-string-indentation"
    # ];
  };

  mkSystemNixSettings =
    pkgs: username:
    commonSettings pkgs
    // cacheSettings
    // {
      trusted-users = [
        "root"
        username
      ];
    };

  mkNixConfig = nixpkgsInput: pkgs: {
    nix = {
      package = lib.mkDefault (
        if pkgs ? lixPackageSets then pkgs.lixPackageSets.stable.lix else pkgs.nix
      );

      nixPath = [ "nixpkgs=${nixpkgsInput}" ];

      registry.nixpkgs.to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        rev = nixpkgsInput.rev;
      };
    };
  };

in
{
  flake.modules.nixos.nix-settings =
    { pkgs, username, ... }:
    (mkNixConfig inputs.nixpkgs pkgs)
    // {
      nix.settings = mkSystemNixSettings pkgs username;

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
        dates = "weekly";
      };
    };

  flake.modules.darwin.nix-settings =
    { pkgs, username, ... }:
    (mkNixConfig inputs.nixpkgs-darwin pkgs)
    // {
      nix.settings =
        mkSystemNixSettings pkgs username
        // {
          sandbox = "relaxed";
        }
        // lib.optionalAttrs pkgs.stdenv.isAarch64 {
          extra-platforms = "x86_64-darwin";
        };

      services.nix-daemon.enableSocketListener = true;

      documentation = {
        enable = false;
        doc.enable = false;
        info.enable = false;
        man.enable = false;
      };
    };

  flake.modules.homeManager.nix-settings =
    { pkgs, ... }:
    {
      nix = {
        package = lib.mkDefault (
          if pkgs ? lixPackageSets then pkgs.lixPackageSets.stable.lix else pkgs.nix
        );

        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
        ];

        registry.nixpkgs.to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
          rev = inputs.nixpkgs.rev;
        };

        settings = {
          use-xdg-base-directories = true;
        };
      };
    };
}

# { inputs, lib, ... }:
# let
#   commonSettings = pkgs: {
#     keep-outputs = true;
#     keep-derivations = true;
#     keep-going = true;
#     builders-use-substitutes = true;
#     allow-unsafe-native-code-during-evaluation = true;
#     accept-flake-config = true;
#     http-connections = 0;
#     use-xdg-base-directories = true;
#     auto-optimise-store = true;
#     max-jobs = "auto";
#
#     experimental-features =
#       if pkgs ? lixPackageSets then
#         lib.mkForce [
#           "flakes"
#           "nix-command"
#           "auto-allocate-uids"
#         ]
#       else
#         lib.mkDefault [
#           "flakes"
#           "nix-command"
#           "auto-allocate-uids"
#           "pipe-operators"
#           "ca-derivations"
#           "dynamic-derivations"
#         ];
#
#     # extra-deprecated-features = lib.optionals (pkgs ? lixPackageSets) [
#     #   "or-as-identifier"
#     #   "broken-string-indentation"
#     # ];
#
#     trusted-substituters = [
#       "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
#       "https://cache.nixos.org?priority=12"
#       "https://nix-community.cachix.org?priority=13"
#       "https://mochouaaaaa.cachix.org"
#     ];
#
#     trusted-public-keys = [
#       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
#       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#       "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
#     ];
#
#     trusted-users = [
#       "root"
#       "mochou"
#     ];
#
#   };
#
#   mkNixConfig = nixpkgsInput: pkgs: {
#     nix = {
#       package = lib.mkDefault (
#         if pkgs ? lixPackageSets then pkgs.lixPackageSets.stable.lix else pkgs.nix
#       );
#       nixPath = [ "nixpkgs=${nixpkgsInput}" ];
#       registry.nixpkgs.to = {
#         type = "github";
#         owner = "NixOS";
#         repo = "nixpkgs";
#         rev = nixpkgsInput.rev;
#       };
#       gc = {
#         automatic = true;
#         options = "--delete-older-than 7d";
#       };
#       settings = commonSettings pkgs;
#     };
#   };
#
# in
# {
#
#   flake.modules.nixos.nix-settings =
#     { pkgs, ... }:
#     (mkNixConfig inputs.nixpkgs pkgs)
#     // {
#       nix.gc.dates = "weekly";
#     };
#
#   flake.modules.darwin.nix-settings =
#     { pkgs, ... }:
#     (mkNixConfig inputs.nixpkgs-darwin pkgs)
#     // {
#       nix.settings =
#         commonSettings pkgs
#         // {
#           sandbox = "relaxed";
#         }
#         // lib.optionalAttrs pkgs.stdenv.isAarch64 {
#           extra-platforms = "x86_64-darwin";
#         };
#
#       system = {
#         tools = {
#           darwin-option.enable = true;
#           darwin-rebuild.enable = true;
#           darwin-uninstaller.enable = true;
#           darwin-version.enable = true;
#         };
#       };
#
#       services.nix-daemon.enableSocketListener = true;
#
#       documentation = rec {
#         enable = false;
#         doc.enable = enable;
#         info.enable = enable;
#         man.enable = enable;
#       };
#
#     };
#
#   # Home Manager also receives the user's Nix client settings, as in the old builder.
#   flake.modules.homeManager.nix-settings = { pkgs, ... }: {
#     nix = {
#       package = lib.mkDefault (
#         if pkgs ? lixPackageSets then pkgs.lixPackageSets.stable.lix else pkgs.nix
#       );
#       nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
#       registry.nixpkgs.to = {
#         type = "github";
#         owner = "NixOS";
#         repo = "nixpkgs";
#         rev = inputs.nixpkgs.rev;
#       };
#       settings = commonSettings pkgs;
#     };
#   };
#
# }
