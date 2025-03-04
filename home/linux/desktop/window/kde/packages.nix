{pkgs, ...}: {
  home.packages = with pkgs; [
    whitesur-kde
    whitesur-icon-theme
    kdePackages.qtstyleplugin-kvantum
    kdePackages.applet-window-buttons6
    kdePackages.qtmultimedia
    kdePackages.kdeconnect-kde
    kdePackages.qttools
    kdePackages.qtsvg
  ];

  # gtk.gtk2.extraConfig = ''
  #   gtk-enable-animations=1
  #   gtk-primary-button-warps-slider=1
  #   gtk-toolbar-style=0
  #   gtk-menu-images=1
  #   gtk-button-images=1
  #   gtk-sound-theme-name="ocean"
  #
  #   gtk-modules=appmenu-gtk-module
  # '';
  gtk = {
    # iconTheme = {
    #   name = "WhiteSur";
    #   package = pkgs.whitesur-icon-theme.overrideAttrs {
    #     themeVariants = ["nord"];
    #     # nautilusStyle = "mojave";
    #   };
    # };
    # theme = {
    #   name = "WhiteSur-dark-nord";
    #   package = pkgs.whitesur-kde;
    # };
  };

  qt.style.name = "kvantum";
}
