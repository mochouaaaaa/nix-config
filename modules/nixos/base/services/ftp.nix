{
  lib,
  myvars,
  ...
}: {
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    localRoot = "/";
    userlistEnable = true;
    userlist = [myvars.username];
    chrootlocalUser = true;
    allowWriteableChroot = true;
    extraConfig = ''
      seccomp_sandbox=NO
      pasv_enable=YES
      pasv_min_port=51000
      pasv_max_port=51999
    '';
  };
}
