{ inputs, ... }:

(
  final: prev:

  let
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
    wrapper = _pkgs: path: (_pkgs.callPackage path callArgs).config.script;

    composed = inputs.nixpkgs.lib.composeManyExtensions [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.niri.overlays.niri
      inputs.nuenv.overlays.default
      (import ./pkgs/flatpak-wrapper.nix)
      (import ./pkgs/obsidian-wrapper.nix)
      (import ./pkgs/tiny-rdm-wrapper.nix)
      (import ./pkgs/jetbrains/pycharm.nix)
      (import ./pkgs/jetbrains/goland.nix)
      (import ./pkgs/jetbrains/clion.nix)
      (import ./pkgs/jetbrains/datagrip.nix)
    ];
  in
  composed final prev
  // {
    nixpaks = {
      wechat-uos = wrapper prev ./pkgs/wechat-uos.nix;
    };
  }
  // {
    waybar_git = inputs.waybar.packages.${final.pkgs.stdenv.hostPlatform.system}.waybar;
  }
)
