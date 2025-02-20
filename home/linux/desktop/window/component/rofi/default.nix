{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  home.file = {
    ".config/rofi" = {
      source = ./config;
      recursive = true;
      force = true;
    };
  };

  services.xremap = {
    config = {
      keymap = [
        {
          name = "Rofi";
          exact_match = true;
          remap = {
            "SUPER-SPACE" = {
              # launch = ["bash" "-c" "rofilaunch.sh"];
              launch = ["bash" "-c" "$HOME/.config/rofi/bin/rofilaunch.sh"];
            };
          };
        }
      ];
    };
  };
}
