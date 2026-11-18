{
  description = "NixOS-only inputs for the nix-config NixOS partition";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-emoji-font.url = "github:zhdsmy/apple-emoji";
    xremap-flake.url = "github:xremap/nix-flake";
    preservation.url = "github:nix-community/preservation";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/348768c1b765fa1b781e72f46e133c6dad1af597";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    hyprland.url = "github:hyprwm/Hyprland/v0.57.2";
    hyprcapture = {
      url = "github:gfhdhytghd/HyprCapture";
      inputs.hyprland.follows = "hyprland";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell?ref=v1.4.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = _: { };
}
