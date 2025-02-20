{
  pkgs,
  myvars,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isEnable = !isDarwin && myvars.packages.vscode;
in {
  programs = {
    vscode = {
      enable = isEnable;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      userSettings = {};
      package =
        (pkgs.vscode.override {
          isInsiders = true;
          commandLineArgs = [
            "--no-sandbox"
            "--ozone-platform-hint=auto"
            "--ozone-platform=wayland"
            # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
            # (only supported by chromium/chrome at this time, not electron)
            "--gtk-version=4"
            # make it use text-input-v1, which works for kwin 5.27 and weston
            "--enable-wayland-ime"

            "--password-store=gnome" # use gnome-keyring as password store
          ];
        })
        .overrideAttrs (oldAttrs: rec {
          src = builtins.fetchTarball {
            url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
            sha256 = "sha256:19m9yrmr7hk08ydd1frs2ibnvncnjjfi0xgjwqarpkfvn9j81vjb";
          };
          version = "latest";
        });
    };
  };
}
