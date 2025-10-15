{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules'.desktop;
in
{
  config = lib.mkIf (cfg.hyprland.enable || cfg.niri.enable || cfg.gnome.enable) {

    home.packages = with pkgs; [
      file-roller
    ];

    xdg.mimeApps = {
      defaultApplications =
        let
          file-roller = [ "org.gnome.FileRoller.desktop" ];
        in
        {
          "application/bzip2" = file-roller;
          "application/gzip" = file-roller;
          "application/vnd.android.package-archive" = file-roller;
          "application/vnd.ms-cab-compressed" = file-roller;
          "application/vnd.debian.binary-package" = file-roller;
          "application/vnd.rar" = file-roller;
          "application/x-7z-compressed" = file-roller;
          "application/x-7z-compressed-tar" = file-roller;
          "application/x-ace" = file-roller;
          "application/x-alz" = file-roller;
          "application/x-apple-diskimage" = file-roller;
          "application/x-ar" = file-roller;
          "application/x-archive" = file-roller;
          "application/x-arj" = file-roller;
          "application/x-brotli" = file-roller;
          "application/x-bzip-brotli-tar" = file-roller;
          "application/x-bzip" = file-roller;
          "application/x-bzip-compressed-tar" = file-roller;
          "application/x-bzip1" = file-roller;
          "application/x-bzip1-compressed-tar" = file-roller;
          "application/x-bzip3" = file-roller;
          "application/x-bzip3-compressed-tar" = file-roller;
          "application/x-cabinet" = file-roller;
          "application/x-cd-image" = file-roller;
          "application/x-compress" = file-roller;
          "application/x-compressed-tar" = file-roller;
          "application/x-cpio" = file-roller;
          "application/x-chrome-extension" = file-roller;
          "application/x-deb" = file-roller;
          "application/x-ear" = file-roller;
          "application/x-ms-dos-executable" = file-roller;
          "application/x-gtar" = file-roller;
          "application/x-gzip" = file-roller;
          "application/x-gzpostscript" = file-roller;
          "application/x-java-archive" = file-roller;
          "application/x-lha" = file-roller;
          "application/x-lhz" = file-roller;
          "application/x-lrzip" = file-roller;
          "application/x-lrzip-compressed-tar" = file-roller;
          "application/x-lz4" = file-roller;
          "application/x-lzip" = file-roller;
          "application/x-lzip-compressed-tar" = file-roller;
          "application/x-lzma" = file-roller;
          "application/x-lzma-compressed-tar" = file-roller;
          "application/x-lzop" = file-roller;
          "application/x-lz4-compressed-tar" = file-roller;
          "application/x-ms-wim" = file-roller;
          "application/x-rar" = file-roller;
          "application/x-rar-compressed" = file-roller;
          "application/x-rpm" = file-roller;
          "application/x-source-rpm" = file-roller;
          "application/x-rzip" = file-roller;
          "application/x-rzip-compressed-tar" = file-roller;
          "application/x-tar" = file-roller;
          "application/x-tarz" = file-roller;
          "application/x-tzo" = file-roller;
          "application/x-stuffit" = file-roller;
          "application/x-war" = file-roller;
          "application/x-xar" = file-roller;
          "application/x-xz" = file-roller;
          "application/x-xz-compressed-tar" = file-roller;
          "application/x-zip" = file-roller;
          "application/x-zip-compressed" = file-roller;
          "application/x-zstd-compressed-tar" = file-roller;
          "application/x-zoo" = file-roller;
          "application/zip" = file-roller;
          "application/zstd" = file-roller;
        };
    };

  };

}
