{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    foliate

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # misc
    ventoy # multi-boot usb creator
  ];

  # GitHub CLI tool
  programs.gh = {enable = true;};
}
