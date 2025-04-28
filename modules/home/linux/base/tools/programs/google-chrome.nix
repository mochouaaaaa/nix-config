{
  pkgs,
  ...
}:
{
  programs = {
    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    # google-chrome = {
    chromium = {
      package = pkgs.chromium;

      # extensions = lib.mkAfter [
      #   { id = "mmlopabfkoikhndekhcgabbhdkdejfhd"; }
      # ];

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        # "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=3"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        # "--enable-wayland-ime"
        "--lang=zh-CN"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };
  };
}
