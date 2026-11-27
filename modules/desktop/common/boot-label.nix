_:
let
  mkDesktop = name: {
    system.nixos = {
      label = "${name}-Desktop";
      # distroName = "${name}-Desktop";
      tags = [ "${name}-Desktop" ];
    };
    boot.loader = {
      grub.configurationName = "${name}-Desktop";
      # limine.style.interface.branding = "${name}-Desktop";
    };
  };
in
{
  flake.aspects = {
    "desktop.hyprland".nixos = mkDesktop "Hyprland";
    "desktop.niri".nixos = mkDesktop "Niri";
    "desktop.umbriel".nixos = mkDesktop "Umbriel";
    "desktop.kde".nixos = mkDesktop "KDE";
  };
}
