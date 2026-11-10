# Desktop module composition

Choose exactly one desktop entry per host; the entries configure their own display manager and session integration.

Desktop modules use dotted names within their module class:

- `self.modules.nixos."desktop.hyprland"` is the NixOS entry point.
- Each NixOS desktop entry automatically adds its matching Home Manager module to the host's `username` Home Manager user.
- `desktop.common`, `desktop.greeter.noctalia`, `desktop.shell.noctalia`, and `desktop.launcher.vicinae` are reusable components.
- `desktop.niri`, `desktop.gnome`, and `desktop.kde` remain separate desktop entries. Niri and GNOME use GDM; KDE uses SDDM.

NixOS and Home Manager remain separate module classes. The NixOS desktop entry composes them by extending only `home-manager.users.<username>.imports`; it does not inject the desktop into every Home Manager user.

Host-specific services (proxy and databases) belong in the host composition, not `desktop.common`. Hardware features such as audio and Bluetooth are explicit imports of each desktop entry. KDE also imports the Plasma Manager Home Manager module required by `programs.plasma`. Automatic login is intentionally left to the host configuration rather than enabled by a desktop profile. KVM tuning is opt-in through `profiles.hardware.kvm.enable` and configured by the host.

Service modules live under `modules/services/` and use dotted module names such as `services.proxy`, `services.mysql`, and `services.virtualisation.qemu`. The host-level `services.base` module contains shared host services; it is not part of a desktop profile.
