{
  flake.modules.nixos."services.virtualisation.virtualbox" =
    {
      username,
      ...
    }:
    {
      users.users.${username}.extraGroups = [ "vboxusers" ];

      virtualisation.virtualbox.host = {
        enable = true;
        enableExtensionPack = true; # 需要 USB 直通/VRDP 时开；注意 Oracle 专有许可
      };
    };
}
