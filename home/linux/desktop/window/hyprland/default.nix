{mylib, ...} @ args: map (path: import path args) [./hyprland.nix ./packages.nix]
