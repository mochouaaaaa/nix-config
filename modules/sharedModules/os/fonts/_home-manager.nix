{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? home-manager) {
    home-manager.sharedModules = [
      {
        profiles.fonts = {
          enable = lib.mkForce false;
          default = lib.mkForce "Monaco Fira Nerd";
        };
      }
    ];
  };

}
