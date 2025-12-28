{
  config,
  ...
}:
let
  cfg = config.modules'.packages.rime;
  rime-data = cfg.data-package;
in
{
  config = {

    modules'.packages.rime.squirrelCustomYaml =
      let
        ascii = {
          ascii_mode = true;
          ascii_punct = true;
        };
      in
      {
        patch = {
          "menu/page_size" = 9;
          "style/candidate_list_layout" = "linear";
          "style/translucency" = true;

          "app_options/com.apple.Spotligh" = ascii;
          "app_options/com.runningwithcrayons.Alfred" = ascii;
          "app_options/com.apple.Terminal" = ascii;
          "app_options/com.github.wez.wezterm" = ascii;
          "app_options/net.kovidgoyal.kitty" = ascii;
          "app_options/com.microsoft.VSCode" = ascii;
          "app_options/com.neovide.neovide" = ascii;
          "app_options/com.tencent.Lemon" = ascii;
          "app_options/com.apple.dt.Xcode" = ascii;
          "app_options/com.nektony.App-Cleaner-SII" = ascii;
          "app_options/com.xunyong.hapigo" = ascii;
          "app_options/com.termius-dmg.mac" = ascii;
          "app_options/com.raycast.macos" = ascii;
          "app_options/com.postmanlabs.mac" = ascii;
          "app_options/com.jetbrains.intellij" = ascii;
          "app_options/com.jetbrains.pycharm" = ascii;
        };
      };

    home.file = {
      "Library/Rime" = {
        source = "${rime-data}/share/rime-data";
        recursive = true;
        force = true;
      };
    };
  };
}
