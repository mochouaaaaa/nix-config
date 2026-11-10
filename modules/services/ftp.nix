{
  flake.modules.nixos."services.ftp" =
    {
      username,
      ...
    }:
    {
      services.vsftpd = {
        enable = true;
        writeEnable = true;
        localUsers = true;
        localRoot = "/home/${username}";
        userlistEnable = true;
        userlist = [ username ];
        chrootlocalUser = true;
        # allowWriteableChroot = true;  # 安全风险，默认关闭
        extraConfig = ''
          pasv_enable=YES
          pasv_min_port=51000
          pasv_max_port=51999
        '';
      };

      networking.firewall = {
        allowedTCPPorts = [ 21 ];
        allowedTCPPortRanges = [
          {
            from = 51000;
            to = 51999;
          }
        ];
      };
    };
}
