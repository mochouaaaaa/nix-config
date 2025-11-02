{
  pkgs,
  lib,
  ...
}:
{
  programs = {
    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    # google-chrome = {
    chromium = {
      package = pkgs.chromium;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        # "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"

        "--password-store=gnome-libsecret"
        "--lang=zh-CN"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
      extensions = [
        { id = "padekgcemlokbadohgkifijomclgjgif"; } # Proxy SwitchyOmega
      ];
    };
  };
}
