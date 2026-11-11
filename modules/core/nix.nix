{
  inputs,
  lib,
  ...
}:
let

  mkNixConfig = nixpkgsInput: pkgs: username: {

    package = lib.mkDefault (
      if (lib.hasAttr "lixPackageSets" pkgs) then pkgs.lixPackageSets.git.lix else pkgs.nix
    );

    nixPath = [ "nixpkgs=${nixpkgsInput}" ];

    registry.nixpkgs.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      inherit (nixpkgsInput) rev;
    };

    channel.enable = false;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    # 定期优化 Nix Store
    optimise = {
      automatic = true;
    };

    settings = {
      # 并行构建
      max-jobs = "auto";
      cores = 0;

      # 构建行为
      keep-outputs = true;
      keep-derivations = true;
      keep-going = true;
      builders-use-substitutes = true;

      # 下载行为
      connect-timeout = 5;
      download-attempts = 3;

      allow-unsafe-native-code-during-evaluation = true;
      accept-flake-config = true;
      http-connections = 0;
      use-xdg-base-directories = true;
      auto-optimise-store = true;

      experimental-features = [
        "flakes"
        "nix-command"
        "auto-allocate-uids"
        "pipe-operators"
        "ca-derivations"
        "dynamic-derivations"
      ];
      extra-deprecated-features = [
        "or-as-identifier"
        "broken-string-escape"
        "broken-string-indentation"
      ];

      trusted-substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
        "https://cache.nixos.org?priority=12"
        "https://nix-community.cachix.org?priority=13"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-users = [ username ];

    };

  };

in
{

  flake.modules.nixos.core =
    {
      lib,
      pkgs,
      username,
      ...
    }:
    {
      nix = lib.recursiveUpdate (mkNixConfig inputs.nixpkgs pkgs username) {
        optimise.dates = "weekly";
        settings = {
          experimental-features = lib.mkForce [
            "flakes"
            "nix-command"
            "auto-allocate-uids"
          ];
        };
      };

    };

  flake.modules.darwin.core =
    {
      lib,
      pkgs,
      username,
      ...
    }:
    {

      nix = lib.recursiveUpdate (mkNixConfig inputs.nixpkgs-darwin pkgs username) {
        settings = {
          sandbox = "relaxed";
          experimental-features = lib.mkForce [
            "flakes"
            "nix-command"
            "auto-allocate-uids"
          ];
        }
        // lib.optionalAttrs pkgs.stdenv.isAarch64 {
          extra-platforms = "x86_64-darwin";
        };
      };
    };

}
