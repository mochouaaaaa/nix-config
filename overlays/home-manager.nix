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
      # nixpaks = {
      #      wechat-uos = wrapper prev ./pkgs/wechat-uos.nix;
      #    };
    })

    (final: prev: {
    })

    inputs.nur.overlays.default
    inputs.vscode-extensions.overlays.default
    inputs.niri.overlays.niri
    inputs.vicinae.overlays.default
    inputs.noctalia.overlays.default
    (import ./pkgs/obsidian-wrapper.nix)
    (import ./pkgs/tiny-rdm-wrapper.nix)
    (import ./pkgs/jetbrains/pycharm.nix)
    (import ./pkgs/jetbrains/goland.nix)
    (import ./pkgs/jetbrains/clion.nix)
    (import ./pkgs/jetbrains/datagrip.nix)
  ];
in
lib.composeManyExtensions overlays final prev
