{ pkgs, ... }:
{
  security = {
    polkit = {
      enable = true;
    };
    pam = {
      services = {
        greetd.enableGnomeKeyring = true;
        swaylock = { };
        hyprlock = { };
      };
    };
  };

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };
}
