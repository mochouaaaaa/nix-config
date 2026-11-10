{
  flake.modules.homeManager."desktop.programs.tencent" = { pkgs, ... }: {
    home.packages = with pkgs; [
      fractal
      nur.repos.so1ve.dingtalk
      feishu
      wechat-uos
      wemeet
    ];
  };

  flake.modules.nixos.preservation =
    {
      self,
      username,
      ...
    }:
    {

      home-manager.users.${username}.imports = [
        self.modules.homeManager."desktop.programs.tencent"
      ];

      profiles.preservation.users.${username}.directories = [
        ".local/share/fractal"
        ".cache/fractal"
        ".config/QQ"
      ];
    };

}
