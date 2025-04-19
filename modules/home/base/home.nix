{
  self,
  lib,
  pkgs,
  config,
  ...
}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit (self.myvars) username;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";

    activation = {
      fixNixProfileSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -L "$HOME/.nix-profile" ] || [ -e "$HOME/.nix-profile" ]; then
          rm -rf "$HOME/.nix-profile"
        fi
        ln -s "${config.home.path}" "$HOME/.nix-profile"
      '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
