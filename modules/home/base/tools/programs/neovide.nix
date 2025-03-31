{
  programs.neovide = {
    enable = true;
    settings = {
      fork = true;
      # frame = "buttonless";
      frame = "full";
      # frame = "none";
      idle = true;
      maximized = false;
      no-multigrid = false;
      srgb = true;
      tabs = true;
      theme = "auto";
      mouse-cursor-icon = "arrow";
      title-hidden = true;
      vsync = true;
      wsl = false;
      font = {
        normal = ["Monaco Nerd Font"]; # Will use the bundled Fira Code Nerd Font by default
        size = 18;
      };
    };
  };
}
