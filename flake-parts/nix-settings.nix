{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:

    let
      isLix = lib.hasAttr "lixPackageSets" pkgs;
    in
    {

      _module.args = {

        nix = {
          nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          package = if isLix then lib.mkForce pkgs.lixPackageSets.stable.lix else pkgs.nix;

          registry.nixpkgs.to = {
            type = "github";
            owner = "NixOS";
            repo = "nixpkgs";
            rev = inputs.nixpkgs.rev;
          };

          channel.enable = false;
          gc = {
            automatic = true;
            options = "--delete-older-than 7d";
          }
          // lib.mkIf (pkgs.stdenv.isLinux) {
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

              experimental-features = lib.mkDefault [
                "flakes"
                "nix-command"
                "auto-allocate-uids"
                "pipe-operators"
                "ca-derivations"
                "dynamic-derivations"
              ];

              trusted-substituters = [
                "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
                "https://cache.nixos.org?priority=12"
                "https://nix-community.cachix.org?priority=13"
                "https://hyprland.cachix.org"
                "https://niri.cachix.org"
                "https://mochouaaaaa.cachix.org"
              ];

              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
                "mochouaaaaa.cachix.org-1:/enIIKfFu959KLIDs0OOHBd9EjnMt53b62Jr2oatV34="
              ];

              max-jobs = "auto";
            }

            (lib.mkIf (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64) { extra-platforms = "x86_64-darwin"; })
            (lib.mkIf pkgs.stdenv.isDarwin { sandbox = "relaxed"; })
          ];

        };

      };
    };

}
