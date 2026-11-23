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
  flake.modules.nixos = {
    "desktop.hyprland" = mkDesktop "Hyprland";
    "desktop.niri" = mkDesktop "Niri";
    "desktop.umbriel" = mkDesktop "Umbriel";
    "desktop.kde" = mkDesktop "KDE";
  };
}
