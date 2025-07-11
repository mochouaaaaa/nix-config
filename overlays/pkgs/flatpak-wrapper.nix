self: super: {
  "flatpak-wrapper" = super.writeShellScriptBin "flatpak-wrapper" ''
    export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
    if [ $# -eq 0 ]; then
        exec ${super.pkgs.lib.getExe super.flatpak} --help
    else
        exec ${super.pkgs.lib.getExe super.flatpak} "$@"
    fi
  '';
}
