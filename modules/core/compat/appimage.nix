{
  flake.aspects = { aspects, ... }: {
    "core.appimage".nixos =
      { pkgs, ... }:
      {
        programs.appimage = {
          enable = true;
          package = pkgs.appimage-run.override {
            extraPkgs = pkgs: [
              pkgs.ffmpeg.lib # 只提供共享库，不含命令行工具
              pkgs.imagemagick
              # 只在确认某个 AppImage 缺失特定库时添加，例如：
              # pkgs.icu
              # pkgs.libxcrypt-legacy
            ];
          };
          binfmt = true;
        };
      };

    desktop-base.includes = [
      aspects."core.appimage"
    ];
  };
}
