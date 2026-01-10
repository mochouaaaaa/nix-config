{ inputs, ... }:

final: prev:
let
  lib = inputs.nixpkgs.lib;

  nixpak = inputs.nixpak;
  callArgs = {
    mkNixPak = nixpak.lib.nixpak {
      inherit (prev) pkgs;
      inherit (prev.pkgs) lib;
    };
    safeBind = sloth: realdir: mapdir: [
      (sloth.mkdir (sloth.concat' sloth.appDataDir realdir))
      (sloth.concat' sloth.homeDir mapdir)
    ];
  };

  overlays = [

    (final: prev: {
      pot = prev.callPackage ./pkgs/pot.nix { };
      jetbra-free = prev.callPackage ./pkgs/jetbra-free { };
      colloid-gtk-theme = prev.callPackage ./pkgs/themes/colloid-gtk-theme.nix { };
      # neovide = prev.callPackage ./pkgs/neovide.nix { };
      # nixpaks = {
      #      wechat-uos = wrapper prev ./pkgs/wechat-uos.nix;
      #    };
    })

    (final: prev: {
      xwayland-satellite =
        inputs.xwayland-satellite.packages.${final.pkgs.stdenv.hostPlatform.system}.default;
    })

    inputs.nur.overlays.default
    inputs.vscode-extensions.overlays.default
    inputs.niri.overlays.niri
    inputs.vicinae.overlays.default
    inputs.hyprland-contrib.overlays.default
    (import ./pkgs/vicinae-wrapper.nix)
    (import ./pkgs/obsidian-wrapper.nix)
    (import ./pkgs/tiny-rdm-wrapper.nix)
    (import ./pkgs/jetbrains/pycharm.nix)
    (import ./pkgs/jetbrains/goland.nix)
    (import ./pkgs/jetbrains/clion.nix)
    (import ./pkgs/jetbrains/datagrip.nix)
    (import ./pkgs/ty.nix)
  ];
in
lib.composeManyExtensions overlays final prev
