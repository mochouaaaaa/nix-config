# Desktop module composition

Desktop entries are NixOS modules that compose the system-side desktop environment with the matching Home Manager module for the Host's primary user. Select one desktop entry per Host unless there is an intentional reason to combine desktop environments.

## Desktop entries

| NixOS module ID | Home Manager module ID | Session |
| --- | --- | --- |
| `desktop.hyprland` | `desktop.hyprland` | Hyprland |
| `desktop.niri` | `desktop.niri` | Niri |
| `desktop.gnome` | `desktop.gnome` | GNOME |
| `desktop.kde` | `desktop.kde` | KDE Plasma |

Each entry imports `desktop.common` and adds only its corresponding Home Manager module to `home-manager.users.<username>.imports`. The NixOS and Home Manager module classes remain separate; the composition is scoped to the Host's primary user rather than every Home Manager user.

Hyprland and Niri also import the Noctalia Greeter component. GNOME uses GDM, while KDE uses SDDM. Automatic login is intentionally left to the Host configuration.

## Shared components

| Module ID | Module class | Responsibility |
| --- | --- | --- |
| `desktop.common` | NixOS + Home Manager | Compatibility aggregate; combines `desktop.base`, `desktop.hardware` and `homeManager.desktop.user` for existing desktop entries. |
| `desktop.base` | NixOS | General desktop system foundations: appearance, desktop security, geolocation, UWSM, XDG portal, printing, power services, X server defaults, graphics integration, and related compatibility settings. |
| `desktop.hardware` | NixOS | General hardware configuration plus the `hardware.desktop` bundle (audio and Bluetooth). |
| `homeManager.desktop.user` | Home Manager | User desktop settings: Rime, appearance, shortcuts, Vicinae, cursor, XDG user directories and portal defaults, MPRIS, and Neovide Wayland integration. |
| `desktop.greeter.noctalia` | NixOS | Noctalia Greeter integration used by Hyprland and Niri. |
| `desktop.shell.noctalia` | Home Manager | Noctalia desktop shell configuration, split into focused component modules. |
| `desktop.launcher.vicinae` | Home Manager | Vicinae launcher configuration and keymap. |
| `desktop.flatpak` | NixOS + Home Manager | Explicit per-user Flatpak client integration and NixOS-to-Home-Manager composition. |

For a normal desktop Host, keep importing `desktop.common`. A Host that needs a narrower composition can import `desktop.base` and/or `desktop.hardware` independently, and add `homeManager.desktop.user` to the intended Home Manager user's imports when user-level desktop settings are wanted. The atomic modules remain independently available; the compatibility aggregate does not replace them.

The Noctalia shell and greeter are separate components. The desktop entry selects the greeter where required; the shell is independently composed by the relevant Home Manager setup.

Host-specific services such as proxy, databases and other server workloads do not belong in the desktop foundations; import them from the Host or a dedicated role instead. KVM tuning remains opt-in through the hardware profile.

## Desktop application profiles

Optional graphical applications are selected independently from the desktop session. Their Home Manager module IDs are registered under `desktop.programs.*`:

- `desktop.programs.api-clients`
- `desktop.programs.browsers`
- `desktop.programs.audio`
- `desktop.programs.security`
- `desktop.programs.communication`
- `desktop.programs.email`
- `desktop.programs.media`
- `desktop.programs.notes`
- `desktop.programs.remote`
- `desktop.programs.office`
- `desktop.programs.networking`

The compatibility aggregate `desktop.programs`, implemented in `modules/programs/desktop/profiles.nix`, imports the application groups above. Hosts can instead import only the groups they need.

Database clients are registered separately as `desktop.programs.database`; they are not included in the compatibility aggregate. The API client group currently includes Hoppscotch and, on non-Darwin systems, Cartero.

## Services and platform boundaries

System service modules live in `modules/services/` and use functional IDs such as `services.proxy`, `services.mysql` and `services.virtualisation.qemu`. They are not implicitly enabled by a desktop profile.

Use the `nixos` module class for system services and compositor/session integration, and `homeManager` for per-user application settings. Platform-specific program behavior belongs in the corresponding Linux, Darwin, NixOS or nix-darwin module.
