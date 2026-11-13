{
  flake.modules.homeManager."desktop.programs.communication" = { pkgs, ... }: {
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
      username,
      ...
    }:
    {
      profiles.preservation.users.${username}.directories = [
        ".local/share/fractal"
        ".cache/fractal"
        ".config/QQ"
      ];
    };

}
