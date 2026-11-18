{
  description = "NixOS-only inputs for the nix-config NixOS partition";

  inputs = {
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    apple-emoji-font.url = "github:zhdsmy/apple-emoji";
    xremap-flake.url = "github:xremap/nix-flake";
    preservation.url = "github:nix-community/preservation";
    nixos-generators.url = "github:nix-community/nixos-generators";
    disko.url = "github:nix-community/disko/348768c1b765fa1b781e72f46e133c6dad1af597";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpak.url = "github:nixpak/nixpak";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    hyprland.url = "github:hyprwm/Hyprland/v0.57.2";
    hyprcapture = {
      url = "github:gfhdhytghd/HyprCapture";
      inputs.hyprland.follows = "hyprland";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    dank-material-shell.url = "github:AvengeMedia/DankMaterialShell?ref=v1.4.4";
    plasma-manager.url = "github:nix-community/plasma-manager";
  };

  outputs = _: { };
}
