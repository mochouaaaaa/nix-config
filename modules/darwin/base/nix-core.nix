{ lib, ... }:
{
  ###################################################################################
  #
  #  Core configuration for nix-darwin
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  # History Issues:
  #  1. Fixed by replace the determined nix-installer by the official one:
  #     https://github.com/LnL7/nix-darwin/issues/149#issuecomment-1741720259
  #
  ###################################################################################

  nixpkgs.hostPlatform = "x86_64-darwin";
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Disable auto-optimise-store because of this issue:
  #   https://github.com/NixOS/nix/issues/7273
  # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
  nix.settings.auto-optimise-store = false;

  nix.gc = {
    automatic = lib.mkDefault true;
    interval = [ { Weekday = 7; } ];
    options = lib.mkDefault "--delete-older-than 7d";
  };

  system.stateVersion = 5;
}
