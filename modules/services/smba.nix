{
  flake.modules.nixos."services.samba" =
    {
      lib,
      pkgs,
      config,

      username,
      ...
    }:
    {
      services.samba = {
        enable = true;
        openFirewall = true;
        package = pkgs.samba;
        settings = {
          global = {
            workgroup = "WORKGROUP";
            "server string" = "smb server share";
            "netbios name" = "smbnix";
            security = "user";
          };
          Share = {
            path = "/home/${username}/Share";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "force user" = username;
            "force group" = username;
          };
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      profiles.preservation.users.${username}.directories = lib.optionals config.services.samba.enable [
        "Share/"
      ];
    };
}
