{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.profiles.packages.firefox;
in
{

  config = lib.mkIf (cfg.enable && config.profiles.desktop.enable) {
    programs = {
      firefox = {
        profiles = {
          ${username} = {
            containersForce = true;
            containers = {
              nix = {
                id = 1;
                name = "nix";
                icon = "briefcase";
                color = "blue";
              };
              github = {
                id = 2;
                name = "github";
                icon = "cart";
                color = "pink";
              };
              llm = {
                id = 3;
                name = "llm";
                icon = "dollar";
                color = "red";
              };
            };
            settings = {
              "privacy.userContext.enabled" = true;
              "privacy.userContext.ui.enabled" = true;
              "extensions.quarantinedDomains.enabled" = true;
            };
            extraConfig = ''
              user_pref("privacy.userContext.longPressBehavior", 2);
            '';
          };
        };
      };
    };
  };
}
