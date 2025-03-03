{
  pkgs,
  myvars,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (sddm-astronaut.override {
      embeddedTheme = "Pixel sakura static";
    })
  ];
  services = {
    displayManager = {
      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = myvars.wm.wayland;
      };
    };
  };
}
