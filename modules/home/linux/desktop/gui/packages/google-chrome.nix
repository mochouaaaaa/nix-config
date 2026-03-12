{
  pkgs,
  lib,
  config,
  ...
}:
let
  desktopCfg = config.profiles.desktop;

  # Dynamically determine the correct password store based on the active DE.
  passwordStore = if desktopCfg.kde.enable then "kde" else "gnome-libsecret"; # Default for GNOME, Hyprland, Niri, etc.
in
{
  programs.chromium = {
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "padekgcemlokbadohgkifijomclgjgif"; } # Proxy SwitchyOmega
    ];

    # Conditionally add native messaging for KDE Plasma integration.
    nativeMessagingHosts = lib.optionals desktopCfg.kde.enable [
      pkgs.kdePackages.plasma-browser-integration
    ];

    # Consolidate all command line arguments, with DE-specific additions.
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform"
      "--enable-wayland-ime"
      "--lang=zh-CN"
      "--password-store=${passwordStore}"
    ]
    # Add DE-specific arguments
    ++ lib.optionals desktopCfg.gnome.enable [ "--gtk-version=4" ]
    ++ lib.optionals desktopCfg.kde.enable [ "--wayland-text-input-version=1" ];
  };
}
