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

  flake.modules.nixos.preservation = { lib, pkgs, config, username, ... }:
    let homePackages = config.home-manager.users.${username}.home.packages or [ ];
    in {
      profiles.preservation.users.${username}.directories =
        lib.optionals (lib.elem pkgs.fractal homePackages) [ ".local/share/fractal" ".cache/fractal" ]
        ++ lib.optionals (pkgs ? qq && lib.elem pkgs.qq homePackages) [ ".config/QQ" ];
    };

}
