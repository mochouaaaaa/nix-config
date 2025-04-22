{
  pkgs,
  lib,
  ...
}:
let
  fildem = import ../component/fildem.nix { inherit pkgs lib; };
in
{
  extensions = with pkgs; [
    {
      package = fildem.name;
      id = fildem.id;
    }
    { package = gnomeExtensions.dash-to-dock; }
    {
      package = gnomeExtensions.unite.overrideAttrs (oldAttrs: rec {
        version = "82";
        src = fetchFromGitHub {
          owner = "hardpixel";
          repo = "unite-shell";
          rev = "v${version}";
          hash = "sha256-Ceo0HQupiihD6GW6/PUbjuArOXtPtAmUPxmNi7DS8E0=";
        };
      });
    }
    { package = gnomeExtensions.xremap; }
    # {package = gnomeExtensions.kimpanel;}
    # --- 联动
    { package = gnomeExtensions.blur-my-shell; }
    # {package = gnomeExtensions.hide-top-bar; }# hide top bar
    { package = gnomeExtensions.coverflow-alt-tab; }
    # ---
    { package = gnomeExtensions.burn-my-windows; } # 关闭动画
    { package = gnomeExtensions.clipboard-indicator; } # 剪切板
    { package = gnomeExtensions.just-perfection; }
    { package = gnomeExtensions.rounded-window-corners-reborn; }
    # 托盘
    { package = gnomeExtensions.tray-icons-reloaded; }
    { package = gnomeExtensions.appindicator; }
    { package = gnomeExtensions.system-monitor; }
    { package = gnomeExtensions.settingscenter; }
    { package = gnomeExtensions.user-themes; }
    { package = gnomeExtensions.auto-move-windows; }
  ];
}
