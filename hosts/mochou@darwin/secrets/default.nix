{ lib, options, ... }:
{

  config = lib.optionalAttrs (options ? age) {

    home-manager.sharedModules = [
      {
        age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyTnhFwOTyrb2gMvEyV6I83L7Xrek8bnzcg2FW6UahY";
      }
    ];

    age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJkVeApTi4ZfRumqsDxKkWd/mPgppuK0dKaapV5OHRI";
  };

}
