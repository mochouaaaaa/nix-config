{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfgDesktop = config.modules.desktop;

in
{
  programs = {
    vscode = {
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles.default.userSettings = { };
      package =
        (pkgs.vscode.override {
          isInsiders = true;
          commandLineArgs =
            [
              "--no-sandbox"
              "--ozone-platform=wayland"
              # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
              # (only supported by chromium/chrome at this time, not electron)
              # make it use text-input-v1, which works for kwin 5.27 and weston
            ]
            ++ lib.optionals (cfgDesktop.kde.enable) [
              "--password-store=kde"
            ]
            ++ lib.optionals (cfgDesktop.hyprland.enable || cfgDesktop.niri.enable) [
              "--gtk-version=4"
              "--ozone-platform-hint=auto"
              "--password-store=gnome"
            ]
            ++ lib.optionals (self.myvars.wm.wayland) [
              # "--enable-features=UseOzonePlatform"
              # "--ozone-platform=wayland"
              # "--enable-wayland-ime"
            ];
        }).overrideAttrs
          (oldAttrs: rec {
            src = builtins.fetchTarball {
              url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
              sha256 = "sha256:02nv4jcjq35xxn3arlcpigvdmcbyy6apn4k00xlhraxm5ilw0q5p";
            };
            version = "latest";
          });
    };
  };

}
