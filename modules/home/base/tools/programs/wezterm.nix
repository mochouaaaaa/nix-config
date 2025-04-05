{ self, ... }:
{
  programs.wezterm = {
    enable = self.myvars.packages.wezterm;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
