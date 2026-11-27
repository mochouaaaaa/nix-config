_:
let
  mkDesktop = name: {
    system.nixos = {
      label = "${name}-Desktop";
      tags = [ "${name}-Desktop" ];
    };
    boot.loader.grub.configurationName = "${name}-Desktop";
  };
in
{
  flake.aspects = _: {
    "desktop.hyprland".nixos = mkDesktop "Hyprland";
    "desktop.niri".nixos = mkDesktop "Niri";
    "desktop.umbriel".nixos = mkDesktop "Umbriel";
    "desktop.kde".nixos = mkDesktop "KDE";
  };
}
