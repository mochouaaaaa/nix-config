{
  services = {
    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      update.auto = {
        # enable = true;
        # onCalendar = "weekly";
      };
      # packages = ["io.github.flattool.Warehouse" "org.virt_manager.virt-manager"];
    };
  };
}
