{
  pkgs,
  myvars,
  ...
}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    package = pkgs.sambaFull;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smb server share";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.1.0/24"; # 替换为你的网段
      };
      "Share" = {
        "path" = "/home/${myvars.username}/Share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        # sudo smbpasswd -a mochou   # set password
        "force user" = "${myvars.username}";
        "force group" = "${myvars.username}";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.allowPing = true;
}
