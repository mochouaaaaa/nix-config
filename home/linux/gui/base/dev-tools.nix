{
  lib,
  pkgs,
  myvars,
  ...
}: {
  home.packages = with pkgs;
    [
      kitty
      clash-verge-rev

      # Automatically trims your branches whose tracking remote refs are merged or gone
      # It's really useful when you work on a project for a long time.
      git-trim
      gitleaks

      # DB
      # navicat-premium

      authenticator
      bitwarden-cli
      bitwarden-desktop

      thunderbird-latest-unwrapped

      netease-cloud-music-gtk
    ]
    ++ lib.optionals myvars.packages.qq [qq]
    ++ lib.optionals myvars.packages.wechat [wechat-uos]
    ++ lib.optionals myvars.packages.telegram [telegram-desktop]
    ++ lib.optionals myvars.packages.pot [pot grim slurp tesseract]
    ++ lib.optionals myvars.packages.flameshot [
      (flameshot.overrideAttrs (oldAttrs: rec {
        name = "flameshot-with-grim"; # 修改包名，避免冲突
        enableWlrSupport = true;
        # patches =
        #   oldAttrs.patches
        #   ++ [
        #     (fetchpatch {
        #       name = "fix-wayland.patch";
        #       url = "https://raw.githubusercontent.com/Elvyria/lovely-patches/refs/heads/main/patches/flameshot/wayland.patch";
        #       sha256 = "8Q4twO5yrU6v0Klc2/EQe+8htIUho99+vYAhFZxs71o=";
        #     })
        #   ];
        buildInputs =
          oldAttrs.buildInputs
          ++ [grim slurp]; # 确保 grim 和 slurp 是构建依赖
        cmakeFlags =
          oldAttrs.cmakeFlags
          ++ lib.optionals stdenv.hostPlatform.isLinux
          ["-DUSE_WAYLAND_GRIM=ON"]; # 启用 USE_WAYLAND_GRIM
      }))
    ];
}
