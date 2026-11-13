# Desktop module composition

Choose exactly one desktop entry per host; the entries configure their own display manager and session integration.

Desktop modules use dotted names within their module class:

- `self.modules.nixos."desktop.hyprland"` is the NixOS entry point.
- Each NixOS desktop entry automatically adds its matching Home Manager module to the host's `username` Home Manager user.
- `desktop.common`, `desktop.greeter.noctalia`, `desktop.shell.noctalia`, and `desktop.launcher.vicinae` are reusable components.
- `desktop.niri`, `desktop.gnome`, and `desktop.kde` remain separate desktop entries. Hyprland and Niri use the Noctalia Greeter; GNOME uses GDM and KDE uses SDDM.

NixOS and Home Manager remain separate module classes. The NixOS desktop entry composes them by extending only `home-manager.users.<username>.imports`; it does not inject the desktop into every Home Manager user.

Host-specific services (proxy and databases) belong in the host composition, not `desktop.common`. Hardware features such as audio and Bluetooth are explicit imports of each desktop entry. KDE also imports the Plasma Manager Home Manager module required by `programs.plasma`. Automatic login is intentionally left to the host configuration rather than enabled by a desktop profile. KVM tuning is opt-in through `profiles.hardware.kvm.enable` and configured by the host.

Service modules live under `modules/services/` and use dotted module names such as `services.proxy`, `services.mysql`, and `services.virtualisation.qemu`. The host-level `services.base` module contains shared host services; it is not part of a desktop profile.

## Optional desktop application profiles

`desktop.common` contains shared desktop infrastructure only; it does not install the optional application suite.

Home Manager application groups are registered independently:

- `desktop.programs.audio`
- `desktop.programs.security`
- `desktop.programs.communication`
- `desktop.programs.email`
- `desktop.programs.media`
- `desktop.programs.notes`
- `desktop.programs.remote`
- `desktop.programs.office`

Import only the groups a host needs from its Home Manager user configuration. The compatibility module `desktop.programs` still imports every group for existing consumers. The `mochou@nixos` host explicitly selects all groups to preserve its existing application set; its Evolution system module is also selected at the host level rather than by `desktop.common`.
