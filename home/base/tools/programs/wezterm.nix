{myvars, ...}: {
  programs.wezterm = {
    enable = myvars.packages.wezterm;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
