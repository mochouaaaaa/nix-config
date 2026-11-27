{
  inputs,
  ...
}:
let

  mkNixConfig = nixpkgsInput: pkgs: username: {
    package = pkgs.nix;

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

      http-connections = 0;
      use-xdg-base-directories = true;
      auto-optimise-store = true;

      accept-flake-config = true;
      experimental-features = [
        "flakes"
        "nix-command"
        "auto-allocate-uids"
        "pipe-operators"
        "ca-derivations"
        "dynamic-derivations"
      ];

      extra-substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      trusted-substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=11"
        "https://cache.nixos.org?priority=20"
        "https://nix-community.cachix.org?priority=21"
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

  flake.aspects.core.nixos =
    {
      lib,
      pkgs,
      username,
      osInput,
      ...
    }:
    {
      nix = lib.recursiveUpdate (mkNixConfig inputs.${osInput} pkgs username) {
        optimise.dates = "weekly";
      };
    };

  # Lix is provided by the NixOS overlay; keep this opt-in module NixOS-only.
  flake.aspects."lix".nixos = { lib, pkgs, ... }: {
    nix = {
      package = lib.mkForce pkgs.lixPackageSets.git.lix;
      settings = {
        extra-deprecated-features = [
          "or-as-identifier"
          "broken-string-escape"
          "broken-string-indentation"
        ];
        experimental-features = lib.mkForce [
          "flakes"
          "nix-command"
          "auto-allocate-uids"
        ];
      };
    };
  };

  flake.aspects."core"."darwin" =
    {
      lib,
      pkgs,
      username,
      osInput,
      ...
    }:
    {
      nix = lib.recursiveUpdate (mkNixConfig inputs.${osInput} pkgs username) {
        settings = {
          sandbox = "relaxed";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isAarch64 {
          extra-platforms = "x86_64-darwin";
        };
      };
    };
}
